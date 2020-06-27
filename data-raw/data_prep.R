## RUN THE CORRESPONDING USE THIS COMMAND AFTER CREATION 
## (WITH OVERWRITE = T IF UPDATING, THEN REBUILD DOCUMENTATION)

pandora_column_types <- readr::read_tsv(
  "data-raw/pandora_column_types.tsv",
  col_types = readr::cols(
    table = readr::col_character(),
    entity_type = readr::col_character(),
    col_name = readr::col_character(),
    type = readr::col_character()
  )
)

pandora_table_elements <- readr::read_tsv(
  "data-raw/pandora_table_elements.tsv",
  col_types = readr::cols(
    table = readr::col_character(),
    entity_type = readr::col_character(),
    name_col = readr::col_character(),
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

#### internal lookup hash tables ####

# hash_col_type
hash_col_type <- hash::hash(
  paste(pandora_column_types$entity_type, pandora_column_types$col_name, sep = "."),
  pandora_column_types$type
)
usethis::use_data(hash_col_type, internal = TRUE, overwrite = TRUE)

#### not yet transformed to the better structure above ####

# List of sidora IDs to PANDORA SQL TABs

entity_map <- pandora_table_elements$table
names(entity_map) <- pandora_table_elements$entity_type

usethis::use_data(entity_map, overwrite = TRUE)

# Column to auxilary table map and
# Table with 'ID' column to the corresponding 'Name' (string) map 

id_2_name_map <- readr::read_tsv(
  "data-raw/id_to_name_map.tsv",
  col_types = cols(.default = "c")
)

usethis::use_data(id_2_name_map, internal = TRUE, overwrite = TRUE)

