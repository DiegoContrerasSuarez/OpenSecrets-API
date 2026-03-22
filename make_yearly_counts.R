library(DBI)
library(RSQLite)
library(dplyr)
library(readr)

sqlite_path <- "data/opensecrets_api.sqlite"
con <- dbConnect(SQLite(), sqlite_path)

years <- 1998:2018

results <- data.frame(
  year = years,
  unique_lobbyists = NA_integer_
)

for (i in seq_along(years)) {
  current_year <- years[i]
  
  query <- paste0("SELECT * FROM lobbyists WHERE Year = ", current_year)
  yearly_data <- dbGetQuery(con, query)
  
  results$unique_lobbyists[i] <- n_distinct(yearly_data$Lobbyist)
  
  rm(yearly_data)
  gc()
}

dbDisconnect(con)

write_csv(results, "data/yearly_lobbyist_counts.csv")

print(results)