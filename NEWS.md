# sidora 2.4.0 - 2023-04-21

## New features

- `get_df()` allows now to request tables not known to sidora.core. The respective error was turned into a warning (#64)
- added a new test to check if `pandora_column_types.tsv` actually specifies all columns in Pandora

## Changes in columns/tables

- TAB_Site: +Date_From, +Date_To, +Date_Info
- TAB_Individual: +Genetic_Sex, +Archaeological_Date_From, +Archaeological_Date_To, +Archaeological_Date_Info, +Archaeological_Culture, +Archaeological_Period, C14_C:N -> C14_C_N
- TAB_Extract: +Robot_Name, -Position_on_Plate, +CoreDB_Lysate_Id
- TAB_Library: +Robot_Name, -Position_on_Plate
- TAB_Capture: +Robot_Name, -Position_on_Plate, +CoreDB_Pool_Id
- TAB_Protocol: +Library_UDG
- +TAB_Archaeological_Culture
- +TAB_Archaeological_Period
- +TAB_Osteological_Age
- +TAB_Sequencing_Setup

# sidora 2.3.3 - 2023-03-28

- Fixed a small bug arising from a change in dplyr 1.1.0. The fix is implemented in a backwards compatible way. See https://github.com/sidora-tools/sidora.core/pull/68

# sidora 2.3.2 - 2022-11-04

- Update dependencies versions in conda environment.yml: r-lang 0.4.11 to 1.0.5

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
  
