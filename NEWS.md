# sidora 2.3.1 - 2022-07-06

- Fix bug in covert_all_ids_to_values() where Index IDs were incorrectly reported to due inconsistency within Pandora in the way it calls index information compared to other tables.

# sidora 2.3.0 - 2022-05-06

- Added new column and auxiliary table information (TAB_Individual)

# sidora 2.2.0 - 2022-05-06

- Added documentation of internal sidora data structure

# sidora 2.1.1

- Added a package start-up message to warn about potential ethical snares.

# sidora 2.1.0

- Added new function `get_field_help()` for printing Pandora webpage help messages on the R console.
- Added support for field CT_scanned.
- Updated renamed column Owning Institution -> Institution of Origin.

# sidora 2.0.3

- A small fix in `format_as_update_existing()`.

# sidora 2.0.2

- Adds a type definition for the CoreDB_Id column in TAB_Sample, TAB_Extract, TAB_Library and TAB_Capture.

# sidora 2.0.1

- Small fixes in the documentation and in an error message.

# sidora 2.0.0 - Phoebe

- Applied some small but breaking changes to the way connections to the Pandora database server are established.

# sidora 1.0.0 - Mnemosyne

- First stable release.
  
