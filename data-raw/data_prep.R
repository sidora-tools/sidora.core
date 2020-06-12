pandora_tables <- c(
  "TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", 
  "TAB_Library", "TAB_Capture", "TAB_Sequencing", 
  "TAB_Raw_Data", "TAB_Sequencing_Sequencer", "TAB_Tag", "TAB_Project",
  "TAB_User"
)

usethis::use_data(pandora_tables)

pandora_tables_restricted <- c("TAB_User")

usethis::use_data(pandora_tables_restricted)

auxtablelookup <- c(
  "Batch" =	"TAB_Batch",
  "Index_Set" =	"TAB_Index_Set",
  "Location" =	"TAB_Location",
  "Location_Bone" =	"TAB_Location",
  "Location_Room" =	"TAB_Location_Room",
  "Location_Bone_Room" =	"TAB_Location_Room",
  "Location_Powder_Room" =	"TAB_Location_Room",
  "Organism" =	"TAB_Organism",
  "Owning_Institution" =	"TAB_Owner",
  "Probe_Set" =	"TAB_Probe_Set",
  "Protocol" =	"TAB_Protocol",
  "Sequencer" =	"TAB_Sequencing_Sequencer",
  "Sequencing_Setup" =	"TAB_Sequencing_Setup",
  "Type" =	"TAB_Type",
  "Type_Group" =	"TAB_Type",
  "Worker" =	"TAB_User",
  "P5_Index_Id" =	"TAB_Index_Set_P5",
  "P7_Index_Id" =	"TAB_Index_Set_P7",
)

usethis::use_data()