# defining global variables
# ugly solution to avoid magrittr NOTE
# see http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
globalVariables(".")

#'@importFrom magrittr "%>%"
#'@importFrom rlang .data 
#'
NULL

startupmsg <- function() {
"
   / \\    Pandora contains many samples that are ethically
  / | \\   and/or culturally sensitive and are therefore
 /  *  \\  off-limits for many analyses.

They are indicated in the column Ethically_culturally_sensitive of TAB_Sample.
Ensure you exclude these samples and all upstream and downstream entries depending on permissions and context!"
}

# package startup message
.onAttach <- function(lib, pkg) {
  if ( interactive() ) { packageStartupMessage(startupmsg()) }
  invisible()
}
