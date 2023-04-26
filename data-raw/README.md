# Data Description

## Usage

To use these tables, fill in new rows accordingly, then run `data_prep.R` to convert these to 
`.rda` objects. The script will convert the tables to fast-lookup hash tables to speed up 
computation.

## Table Description

Each table used for loading, formatting, joining etc. Pandora tables in sidora are described below.

### pandora_column_types.tsv

This stores metadata about each column of each table.

| Column            | Description                                                                                                              |
|-------------------|--------------------------------------------------------------------------------------------------------------------------|
| table             | Pandora SQL database table name prefixed by `TAB_`                                                                       |
| entity_type       | Sidora simplified version of the name in `table`. Used for prefixing column names during data loading                    |
|	col_name	        | Name of the column in `table`                                                                                            |
| type	            | Data type of the column (integer, character, etc.)                                                                       |
| auxiliary_table	  | Whether the column contains an Id that must be looked up against a Pandora 'auxiliary' table                             |
| auxiliary_namecol	| The full character-type name of the column in the auxiliary table corresponding to the integer Id type in the main table |
| update_col_type   | Whether this column is mandatory to be included when using the Pandora web interface's 'upload' function                 |

### pandora_table_elements.tsv

This stores metadata about each table itself.

| Column            | Description                                                                                                              |
|-------------------|--------------------------------------------------------------------------------------------------------------------------|
| table             | Pandora SQL database table name prefixed by `TAB_`                                                                       |
| entity_type       | Sidora simplified version of the name in `table`. Used for prefixing column names during data loading                    |
| namecol	          | Name of column containing the full text-based ID of a given entry in the database                                        |
| restricted	      | Whether this table is accessible to normal users (i.e. `pandora_read`)                                                   |
| requires_prejoin	| Whether this table needs to be joined with another auxiliary table before display                                         |
| idcol             | Name of column containing the numeric Id of a given entry in the database                                                |
