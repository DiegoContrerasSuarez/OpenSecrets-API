library(DBI)
library(RSQLite)

source_db <- "data/opensecretslobbying.sqlite"
small_db <- "data/opensecrets_api.sqlite"

# delete old small db if it exists
if (file.exists(small_db)) {
  file.remove(small_db)
}

con_in <- dbConnect(SQLite(), source_db)
con_out <- dbConnect(SQLite(), small_db)

# table 1: yearly counts
yearly_counts <- dbGetQuery(con_in, "
  SELECT Year, COUNT(DISTINCT Lobbyist) AS unique_lobbyists
  FROM lobbyists
  GROUP BY Year
  ORDER BY Year
")

dbWriteTable(con_out, "yearly_counts", yearly_counts, overwrite = TRUE)

# table 2: search table with distinct lobbyists only
lobbyist_search <- dbGetQuery(con_in, "
  SELECT DISTINCT Lobbyist, Lobbyist_id, OfficialPosition
  FROM lobbyists
  WHERE Lobbyist IS NOT NULL
")

dbWriteTable(con_out, "lobbyist_search", lobbyist_search, overwrite = TRUE)

dbDisconnect(con_in)
dbDisconnect(con_out)