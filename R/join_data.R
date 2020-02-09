#' Join multiple tables
#'
#' @param df_list Named list of tables as produced by \code{get_df_list}
#'
#' @return Joined dataframe
#' @export
join_df_list <- function(df_list) {
  
  if (length(df_list) == 1) {
    return(df_list[[1]])
  }
  
  join_order_vector <- c(
    "TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", "TAB_Library"
  )
  
  tabs <- names(df_list)
  
  if (!check_completeness(tabs, join_order_vector)) {
    stop("Missing intermediate table.")
  }
  
  return_table <- ""
    
  if (all(c("TAB_Site", "TAB_Individual") %in% tabs)) {
    df_list[["TAB_Individual"]] <- dplyr::left_join(
      df_list[["TAB_Individual"]], 
      df_list[["TAB_Site"]], 
      by = ("Site" = "Id"), 
      suffix = c(".Individual", ".Site")
    )
    return_table <- "TAB_Individual"
  }
  
  if (all(c("TAB_Individual", "TAB_Sample") %in% tabs)) {
    df_list[["TAB_Sample"]] <- dplyr::left_join(
      df_list[["TAB_Sample"]], 
      df_list[["TAB_Individual"]], 
      by = ("Individual" = "Id"), 
      suffix = c(".Sample", ".Individual")
    )
    return_table <- "TAB_Sample"
  }
  
  if (all(c("TAB_Sample", "TAB_Extract") %in% tabs)) {
    df_list[["TAB_Extract"]] <- dplyr::left_join(
      df_list[["TAB_Extract"]], 
      df_list[["TAB_Sample"]], 
      by = ("Sample" = "Id"), 
      suffix = c(".Extract", ".Sample")
    )
    return_table <- "TAB_Extract"
  }
  
  if (all(c("TAB_Extract", "TAB_Library") %in% tabs)) {
    df_list[["TAB_Library"]] <- dplyr::left_join(
      df_list[["TAB_Library"]], 
      df_list[["TAB_Extract"]], 
      by = ("Extract" = "Id"), 
      suffix = c(".Library", ".Extract")
    )
    return_table <- "TAB_Library"
  }
  
  return(df_list[[return_table]])
}

check_completeness <- function(tabs, join_order_vector) {
  all(sapply(
    utils::combn(tabs, 2, simplify = F), function(x) {
      a_pos <- which(x[1] == join_order_vector)
      b_pos <- which(x[2] == join_order_vector)
      if (b_pos < a_pos) { inter_b <- b_pos; inter_a <- a_pos; b_pos <- inter_a; a_pos <- inter_b }
      inds <- 1:length(join_order_vector)
      inds <- inds[inds > a_pos & inds < b_pos]
      all(join_order_vector[inds] %in% tabs)
    }
  ))
}


