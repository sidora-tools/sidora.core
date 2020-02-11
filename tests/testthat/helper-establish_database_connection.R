# This code runs before the tests.

creds <- readLines(".credentials")
con <- DBI::dbConnect(
  RMariaDB::MariaDB(), 
  host = creds[1],
  user = creds[2],
  password = creds[3],
  db = "pandora"
)
