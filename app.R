library(plumber)
library(DBI)
library(RSQLite)

sqlite_path <- "data/opensecrets_api.sqlite"

get_db_connection <- function() {
  dbConnect(SQLite(), sqlite_path)
}

#* API status
#* @get /
function() {
  list(
    message = "OpenSecrets API is running.",
    endpoints = list(
      "/" = "Status message",
      "/lobbyists?year=2016" = "Unique lobbyist count for a given year",
      "/timeseries" = "Full yearly time series",
      "/search?name=SMITH" = "Search lobbyists by name"
    )
  )
}

#* Get unique lobbyist count for one year
#* @param year:int Year between 1998 and 2018
#* @get /lobbyists
function(year = 2016) {
  year <- as.integer(year)
  
  if (is.na(year) || year < 1998 || year > 2018) {
    return(list(error = "Please provide a year between 1998 and 2018."))
  }
  
  con <- get_db_connection()
  on.exit(dbDisconnect(con), add = TRUE)
  
  query <- paste0(
    "SELECT Year, unique_lobbyists
     FROM yearly_counts
     WHERE Year = ", year
  )
  
  result <- dbGetQuery(con, query)
  
  if (nrow(result) == 0) {
    return(list(error = "No data found for that year."))
  }
  
  list(
    year = result$Year[1],
    unique_lobbyists = result$unique_lobbyists[1]
  )
}

#* Get full time series
#* @get /timeseries
function() {
  con <- get_db_connection()
  on.exit(dbDisconnect(con), add = TRUE)
  
  result <- dbGetQuery(con, "
    SELECT Year, unique_lobbyists
    FROM yearly_counts
    ORDER BY Year
  ")
  
  list(data = result)
}

#* Search lobbyists by name
#* @param name Search text
#* @get /search
function(name = "") {
  if (name == "") {
    return(list(error = "Please provide a search term, for example /search?name=SMITH"))
  }
  
  con <- get_db_connection()
  on.exit(dbDisconnect(con), add = TRUE)
  
  safe_name <- gsub("'", "''", name)
  
  query <- paste0(
    "SELECT Lobbyist, Lobbyist_id, OfficialPosition
     FROM lobbyist_search
     WHERE UPPER(Lobbyist) LIKE UPPER('%", safe_name, "%')
     LIMIT 50"
  )
  
  result <- dbGetQuery(con, query)
  
  list(
    query = name,
    matches = result
  )
}