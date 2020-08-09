#' Join multiple \strong{PANDORA table}s
#'
#' Some Pandora tables can be merged following a hierarchical, pair-wise logic 
#' of primary and foreign keys. \code{join_pandora_tables()} is a join function 
#' which is aware of this logic and automatically combines lists of data.frames 
#' with Pandora tables (as produced by \code{get_con_list()} or \code{get_df_list()}) 
#' to long data.frames.
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
      x[["TAB_Site"]], 
      x[["TAB_Individual"]], 
      by = c("site.Id" = "individual.Site")
    ) %>%
      dplyr::mutate(
        individual.Site = .data[["site.Id"]]
      )
    return_table <- "TAB_Individual"
  }
  
  if (all(c("TAB_Individual", "TAB_Sample") %in% tabs)) {
    x[["TAB_Sample"]] <- dplyr::left_join(
      x[["TAB_Individual"]], 
      x[["TAB_Sample"]], 
      by = c("individual.Id" = "sample.Individual")
    ) %>%
      dplyr::mutate(
        sample.Individual = .data[["individual.Id"]]
      )
    return_table <- "TAB_Sample"
  }
  
  if (all(c("TAB_Sample", "TAB_Extract") %in% tabs)) {
    x[["TAB_Extract"]] <- dplyr::left_join(
      x[["TAB_Sample"]], 
      x[["TAB_Extract"]], 
      by = c("sample.Id" = "extract.Sample")
    ) %>%
      dplyr::mutate(
        extract.Sample = .data[["sample.Id"]]
      )
    return_table <- "TAB_Extract"
  }
  
  if (all(c("TAB_Extract", "TAB_Library") %in% tabs)) {
    x[["TAB_Library"]] <- dplyr::left_join(
      x[["TAB_Extract"]], 
      x[["TAB_Library"]], 
      by = c("extract.Id" = "library.Extract")
    ) %>%
      dplyr::mutate(
        library.Extract = .data[["extract.Id"]]
      )
    return_table <- "TAB_Library"
  }
  
  if (all(c("TAB_Library", "TAB_Capture") %in% tabs)) {
    x[["TAB_Capture"]] <- dplyr::left_join(
      x[["TAB_Library"]], 
      x[["TAB_Capture"]], 
      by = c("library.Id" = "capture.Library")
    ) %>%
      dplyr::mutate(
        capture.Library = .data[["library.Id"]]
      )
    return_table <- "TAB_Capture"
  }
  
  if (all(c("TAB_Capture", "TAB_Sequencing") %in% tabs)) {
    x[["TAB_Sequencing"]] <- dplyr::left_join(
      x[["TAB_Capture"]], 
      x[["TAB_Sequencing"]], 
      by = c("capture.Id" = "sequencing.Capture")
    ) %>%
      dplyr::mutate(
        sequencing.Capture = .data[["capture.Id"]]
      )
    return_table <- "TAB_Sequencing"
  }
  
  if (all(c("TAB_Sequencing", "TAB_Raw_Data") %in% tabs)) {
    x[["TAB_Raw_Data"]] <- dplyr::left_join(
      x[["TAB_Sequencing"]], 
      x[["TAB_Raw_Data"]], 
      by = c("sequencing.Id" = "raw_data.Sequencing")
    ) %>%
      dplyr::mutate(
        raw_data.Sequencing = .data[["sequencing.Id"]]
      )
    return_table <- "TAB_Raw_Data"
  }
  
  if (all(c("TAB_Raw_Data", "TAB_Analysis") %in% tabs)) {
    x[["TAB_Analysis"]] <- dplyr::left_join(
      x[["TAB_Raw_Data"]], 
      x[["TAB_Analysis"]], 
      by = c("raw_data.Id" = "analysis.Raw_Data")
    ) %>%
      dplyr::mutate(
        analysis.Raw_Data = .data[["raw_data.Id"]]
      )
    return_table <- "TAB_Analysis"
  }
  
  return(x[[return_table]])
}

#### helpers ####

check_completeness <- function(
  tabs, 
  join_order_vector = sidora.core::pandora_tables
) {
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

#' Make sequence-complete Pandora table list
#'
#' Pandoras layout is a hierarchical sequence of tables: All tables have a clear 
#' predecessor and successor. \code{join_pandora_tables()} uses this fact to 
#' merge tables accordingly. \code{make_complete_table_list} is
#' a helper function to fill the gaps in a sequence of Pandora tables.
#'
#' @param tabs character vector. List of Pandora table names
#' @param join_order_vector character vector. Reference vector with the Pandora 
#' structure
#'
#' @export
make_complete_table_list <- function(
  tabs,
  join_order_vector = sidora.core::pandora_tables
) {
  positions <- sapply(tabs, function(x) { which(x == join_order_vector) })
  res <- join_order_vector[seq(min(positions), max(positions), 1)]
  return(res)
}
  
  
