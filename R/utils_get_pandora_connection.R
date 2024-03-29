#' Get the connection object for the Pandora DB 
#' 
#' @param cred_file character. Path to a credentials file containing four lines
#' listing the database host, the port of the database server, user and password,
#' respectively
#'
#' @return A Pandora DB connection object
#' 
#' @export
get_pandora_connection <- function(cred_file = ".credentials") {
  
  #check_if_packages_are_available("RMariaDB")
  
  if (!file.exists(cred_file)) {
    stop(paste(
      "[sidora.core] error: can't find .credentials file. Please create one ",
      "containing four lines:", 
      "the database host, port of the database server, the username, the password."
    ))
  }
  
  creds <- readLines(cred_file)
  con <- DBI::dbConnect(
    RMariaDB::MariaDB(), 
    host = creds[1],
    port = creds[2],
    user = creds[3],
    password = creds[4],
    db = "pandora"
  )
  
  return(con)
}
