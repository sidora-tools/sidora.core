# This code runs before the tests.

# should not run on travis
if (Sys.getenv("USER") != "travis") {

  creds <- readLines(".credentials")
  con <- DBI::dbConnect(
    RMariaDB::MariaDB(), 
    host = creds[1],
    user = creds[2],
    password = creds[3],
    db = "pandora"
  )

}