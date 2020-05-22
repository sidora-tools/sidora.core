pandora_tables <- c(
  "TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", 
  "TAB_Library", "TAB_Capture", "TAB_Sequencing", 
  "TAB_Raw_Data", "TAB_Sequencing_Sequencer", "TAB_Tag", "TAB_Project",
  "TAB_User"
)

usethis::use_data(pandora_tables)

pandora_tables_restricted <- c("TAB_User")

usethis::use_data(pandora_tables_restricted)
