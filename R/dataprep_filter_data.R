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
