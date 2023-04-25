context("pandora_column_types.tsv")

test_that("all columns in Pandora tables are defined in sidora.core", {
  
  skip_on_ci()
  
  # get all tables and their columns in Pandora
  all_tables <- unique(c(pandora_tables, pandora_tables_restricted))
  cons_to_all_tables <- get_con_list(all_tables, con)
  
  pandora_columns <- cons_to_all_tables %>%
    purrr::map2_dfr(names(.), ., function(pandora_table_name, pandora_table_con) {
      tibble::tibble(table = pandora_table_name, col_name = colnames(pandora_table_con))
    }) %>%
    dplyr::arrange(table, col_name) %>%
    dplyr::mutate(
      column = paste0(table, "::", col_name)
    ) %>% dplyr::pull("column")
  
  # get all tables and columns sidora.core knows
  sidora_columns <- pandora_column_types %>%
    dplyr::select(table, col_name) %>%
    dplyr::arrange(table, col_name) %>%
    dplyr::mutate(
      column = paste0(table, "::", col_name)
    ) %>% dplyr::pull("column")
  
  # compare column lists
  in_pandora_not_sidora <- setdiff(pandora_columns, sidora_columns)
  in_sidora_not_pandora <- setdiff(sidora_columns, pandora_columns)
  
  if (length(c(in_pandora_not_sidora, in_sidora_not_pandora)) != 0) {
    warning(
      "Columns in Pandora, but not pandora_column_types.tsv:\n",
      if (length(in_pandora_not_sidora) == 0) {"none"} else {
      paste(in_pandora_not_sidora, collapse = ", ") },
      "\n",
      "Columns in pandora_column_types.tsv, but not Pandora:\n",
      if (length(in_sidora_not_pandora) == 0) {"none"} else {
      paste(in_sidora_not_pandora, collapse = ", ") }
    )
  }
  
  # check if the pandora and the sidora column selection is equal
  expect_identical(pandora_columns, sidora_columns)
  
})
