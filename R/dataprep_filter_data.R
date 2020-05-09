#' Filter a merged PANDORA table by project or tag
#'
#' @param x data.frame
#' @param col character. String column in x (e.g. "Projects.Individual" or "Tags.Individual") on which
#' the filter process should be applied
#' @param ins character vector. Projects or tags you want to see 
#' @param outs character vector. Projects of tags you do not want to see
#'
#' @return filtered data.frame
#' 
#' @export
filter_pr_tag <- function(x, col, ins = c(), outs = c()) {

  if (length(ins) != 0 && is.na(ins)) { ins <- c() }
  if (length(outs) != 0 && is.na(outs)) { outs <- c() }
  
  if (!(length(ins) == 0) & (length(outs) == 0)) {
    dplyr::filter(x, is_in(ins, .data[[col]]))
  } else if ((length(ins) == 0) & !(length(outs) == 0)) {
    dplyr::filter(x, !is_in(outs, .data[[col]]))
  } else if (!(length(ins) == 0) & !(length(outs) == 0)) {
    dplyr::filter(x, is_in(ins, .data[[col]]) & !is_in(outs, .data[[col]]))
  } else {
    x
  }
  
}

is_in <- function (ss, vec) {
  list_of_grep_result_vectors <- lapply(ss, function(s) { grepl(s, vec) })
  purrr::reduce(list_of_grep_result_vectors, `|`)
}

#' Filter a merged PANDORA table by date
#'
#' @param x data.frame
#' @param col character. String column in x (e.g. "Creation_Date.Site" or "Creation_Date.Individual") on which
#' the filter process should be applied
#' @param start Date. Start date of selection. Can also be supplied as a character (with format as defined in the format argument)
#' @param end Date. End date of selection. Can also be supplied as a character (with format as defined in the format argument)
#' @param format character. Date format definition relevant if start and end are supplied as characters
#'
#' @return filtered data.frame
#' 
#' @export
filter_date <- function(x, col, start = NA, end = NA, format = "%Y-%m-%d") {
  
  if (is.na(start)) { start <- min(x[[col]], na.rm = T) }
  if (is.na(end)) { end <- max(x[[col]], na.rm = T) }
  if (is.character(start)) { start <- as.Date(start, format) }
  if (is.character(end)) { end <- as.Date(end, format) }
  
  x %>% dplyr::filter(
    .data[[col]] >= start,
    .data[[col]] <= end
  )
  
}
