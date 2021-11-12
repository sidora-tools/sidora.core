# This code runs before the tests.

# should not run on travis
if (!isTRUE(as.logical(Sys.getenv("CI")))) {

  # path to credentials file that is also valid in case of check
  cred_file <- file.path(gsub(".Rcheck", "", getwd()), ".credentials")
  
  creds <- readLines(cred_file)
  con <- DBI::dbConnect(
    RMariaDB::MariaDB(), 
    host = creds[1],
    port = creds[2],
    user = creds[3],
    password = creds[4],
    db = "pandora"
  )

}