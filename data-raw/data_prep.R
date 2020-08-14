## RUN THE CORRESPONDING USE THIS COMMAND AFTER CREATION 
## (WITH OVERWRITE = T IF UPDATING, THEN REBUILD DOCUMENTATION)

#### load raw data #### 

pandora_column_types <- readr::read_tsv(
  "data-raw/pandora_column_types.tsv",
  col_types = readr::cols(
    table = readr::col_character(),
    entity_type = readr::col_character(),
    col_name = readr::col_character(),
    type = readr::col_character(),
    auxiliary_table = readr::col_character(),
    update_col_type = readr::col_character()
  )
)

pandora_table_elements <- readr::read_tsv(
  "data-raw/pandora_table_elements.tsv",
  col_types = readr::cols(
    table = readr::col_character(),
    entity_type = readr::col_character(),
    namecol = readr::col_character(),
    restricted = readr::col_logical()
  )
)

#### tables and vectors for export ####

# pandora_column_types
usethis::use_data(pandora_column_types, overwrite = TRUE)

# pandora_table_elements
usethis::use_data(pandora_table_elements, overwrite = TRUE)

# pandora_tables
pandora_tables <- pandora_table_elements$table[!pandora_table_elements$restricted]
usethis::use_data(pandora_tables, overwrite = TRUE)

# pandora_tables_restricted
pandora_tables_restricted <- pandora_table_elements$table[pandora_table_elements$restricted]
usethis::use_data(pandora_tables_restricted, overwrite = TRUE)

# pandora_tables_all
pandora_tables_all <- pandora_table_elements$table
usethis::use_data(pandora_tables_all, overwrite = TRUE)

pandora_tables_prejoin <- pandora_table_elements$table[pandora_table_elements$requires_prejoin]
usethis::use_data(pandora_tables_prejoin, overwrite = TRUE)

#### internal lookup hash tables ####

# hash_sidora_col_name_col_type
hash_sidora_col_name_col_type <- hash::hash(
  paste(pandora_column_types$entity_type, pandora_column_types$col_name, sep = "."),
  pandora_column_types$type
)

# hash_entity_type_table_name
hash_entity_type_table_name <- hash::hash(
  pandora_table_elements$entity_type,
  pandora_table_elements$table
)

# hash_table_name_entity_type
hash_table_name_entity_type <- hash::hash(
  pandora_table_elements$table,
  pandora_table_elements$entity_type
)

# hash_entity_type_namecol
hash_entity_type_namecol <- hash::hash(
  pandora_table_elements$entity_type,
  paste(pandora_table_elements$entity_type, pandora_table_elements$namecol, sep = ".")
)

# hash_entity_type_idcol
hash_entity_type_idcol <- hash::hash(
  pandora_table_elements$entity_type,
  paste(pandora_table_elements$entity_type, pandora_table_elements$idcol, sep = ".")
)

# hash_sidora_col_name_auxiliary_table
pandora_column_types_with_auxiliary_table <- pandora_column_types[!is.na(pandora_column_types$auxiliary_table),]
hash_sidora_col_name_auxiliary_table <- hash::hash(
  paste(pandora_column_types_with_auxiliary_table$entity_type, pandora_column_types_with_auxiliary_table$col_name, sep = "."),
  pandora_column_types_with_auxiliary_table$auxiliary_table
)

# hash_sidora_col_name_auxiliary_namecol
pandora_column_types_with_auxiliary_namecol <- pandora_column_types[!is.na(pandora_column_types$auxiliary_namecol),]
hash_sidora_col_name_auxiliary_namecol <- hash::hash(
  paste(pandora_column_types_with_auxiliary_table$entity_type, pandora_column_types_with_auxiliary_table$col_name, sep = "."),
  paste(
    hash::values(hash_table_name_entity_type, pandora_column_types_with_auxiliary_table$auxiliary_table), 
    pandora_column_types_with_auxiliary_table$auxiliary_namecol, sep = "."
  )
)

# hash_pandora_col_name_update_type
hash_pandora_col_name_update_type <- hash::hash(
  paste(pandora_column_types$entity_type, pandora_column_types$col_name, sep = "."),
  pandora_column_types$update_col_type
)


usethis::use_data(
  hash_sidora_col_name_col_type,
  hash_entity_type_table_name,
  hash_table_name_entity_type,
  hash_sidora_col_name_auxiliary_table,
  hash_entity_type_namecol,
  hash_entity_type_idcol,
  hash_sidora_col_name_auxiliary_namecol,
  hash_pandora_col_name_update_type,
  internal = TRUE, overwrite = TRUE
)
