#' Join multiple \strong{PANDORA table}s
#'
#' See readme for more information.
#'
#' @param x named list of data.frames or connections (\strong{PANDORA table}s) as returned by 
#' \code{get_con_list} or \code{get_df_list}
#'
#' @return data.frame (joined from multiple data.frames)
#' @export
join_pandora_tables <- function(x) {
  
  if (length(x) == 1) { return(x[[1]]) }
  tabs <- names(x)
  if (!check_completeness(tabs)) { stop("Missing intermediate table.") }
  
  return_table <- ""
    
  if (all(c("TAB_Site", "TAB_Individual") %in% tabs)) {
    x[["TAB_Individual"]] <- dplyr::left_join(
      x[["TAB_Site"]] %>% dplyr::rename("Site" = "Id"), 
      x[["TAB_Individual"]], 
      by = "Site", 
      suffix = c(".Site", ".Individual")
    )
    return_table <- "TAB_Individual"
  }
  
  if (all(c("TAB_Individual", "TAB_Sample") %in% tabs)) {
    x[["TAB_Sample"]] <- dplyr::left_join(
      x[["TAB_Individual"]] %>% dplyr::rename("Individual" = "Id"), 
      x[["TAB_Sample"]], 
      by = "Individual", 
      suffix = c(".Individual", ".Sample")
    )
    return_table <- "TAB_Sample"
  }
  
  if (all(c("TAB_Sample", "TAB_Extract") %in% tabs)) {
    x[["TAB_Extract"]] <- dplyr::left_join(
      x[["TAB_Sample"]] %>% dplyr::rename("Sample" = "Id"), 
      x[["TAB_Extract"]], 
      by = "Sample", 
      suffix = c(".Sample", ".Extract")
    )
    return_table <- "TAB_Extract"
  }
  
  if (all(c("TAB_Extract", "TAB_Library") %in% tabs)) {
    x[["TAB_Library"]] <- dplyr::left_join(
      x[["TAB_Extract"]] %>% dplyr::rename("Extract" = "Id"), 
      x[["TAB_Library"]], 
      by = "Extract", 
      suffix = c(".Extract", ".Library")
    )
    return_table <- "TAB_Library"
  }
  
  if (all(c("TAB_Library", "TAB_Capture") %in% tabs)) {
    x[["TAB_Capture"]] <- dplyr::left_join(
      x[["TAB_Library"]] %>% dplyr::rename("Library" = "Id"), 
      x[["TAB_Capture"]], 
      by = "Library", 
      suffix = c(".Library", ".Capture")
    )
    return_table <- "TAB_Capture"
  }
  
  if (all(c("TAB_Capture", "TAB_Sequencing") %in% tabs)) {
    x[["TAB_Sequencing"]] <- dplyr::left_join(
      x[["TAB_Capture"]] %>% dplyr::rename("Capture" = "Id"), 
      x[["TAB_Sequencing"]], 
      by = "Capture", 
      suffix = c(".Capture", ".Sequencing")
    )
    return_table <- "TAB_Sequencing"
  }
  return(x[[return_table]])
}

#### helpers ####

check_completeness <- function(tabs) {
  join_order_vector <- c(
    "TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", "TAB_Library", "TAB_Capture", "TAB_Sequencing", 
    "TAB_Raw_Data", "TAB_Analysis", "TAB_Analysis_Result_String"
  )
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

