# This code runs before the tests.

# should not run on travis
if (Sys.getenv("USER") != "travis") {

  # path to credentials file that is also valid in case of check
  cred_file <- file.path(gsub(".Rcheck", "", getwd()), ".credentials")
  
  creds <- readLines(cred_file)
  con <- DBI::dbConnect(
    RMariaDB::MariaDB(), 
    host = creds[1],
    user = creds[2],
    password = creds[3],
    db = "pandora"
  )

}