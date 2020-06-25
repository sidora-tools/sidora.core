## RUN THE CORRESPONDING USE THIS COMMAND AFTER CREATION 
## (WITH OVERWRITE = T IF UPDATING, THEN REBUILD DOCUMENTATION)

## List of loadable pandora tables
pandora_tables <- c(
  "TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", 
  "TAB_Library", "TAB_Capture", "TAB_Sequencing", 
  "TAB_Raw_Data", "TAB_Sequencing_Sequencer", "TAB_Tag", "TAB_Project",
  "TAB_User", "TAB_Batch", "TAB_Index_Set", "TAB_Location", "TAB_Location_Room",
  "TAB_Organism", "TAB_Owner", "TAB_Probe_Set", "TAB_Type", "TAB_User",
  "TAB_Index_Set_P5", "TAB_Index_Set_P7"
)

usethis::use_data(pandora_tables)

## List of restricted pandora tables that require special processing
pandora_tables_restricted <- c("TAB_User")

usethis::use_data(pandora_tables_restricted)

## List of sidora IDs to PANDORA SQL TABs

entity_map <- c(
  site = "TAB_Site",
  individual = "TAB_Individual",
  sample = "TAB_Sample",
  extract = "TAB_Extract",
  library = "TAB_Library",
  capture = "TAB_Capture",
  sequencing = "TAB_Sequencing",
  raw_data = "TAB_Raw_Data",
  sequencer = "TAB_Sequencing_Sequencer",
  tag = "TAB_Tag",
  project = "TAB_Project",
  #user = "TAB_User",
  sequencing_setup = "TAB_Sequencing_Setup",
  batch = "TAB_Batch",
  index_set = "TAB_Index_Set",
  location = "TAB_Location",
  location_room = "TAB_Location_Room",
  organism = "TAB_Organism",
  owner = "TAB_Owner",
  probe_set = "TAB_Probe_Set",
  protocol = "TAB_Protocol",
  sequencing_setup = "TAB_Sequencing_Setup",
  sample_type = "TAB_Type",
  worker = "TAB_User",
  index_p5 = "TAB_Index_Set_P5",
  index_p7 = "TAB_Index_Set_P7"
)

usethis::use_data(entity_map)

## Column to auxilary table map

auxtablelookup <- c(
  "Batch" =	"TAB_Batch",
  "Index_Set" =	"TAB_Index_Set",
  "Location" =	"TAB_Location",
  "Location_Bone" =	"TAB_Location",
  "Location_Room" =	"TAB_Location_Room",
  "Location_Bone_Room" =	"TAB_Location_Room",
  "Location_Powder_Room" =	"TAB_Location_Room",
  "Organism" =	"TAB_Organism",
  "Owning_institution" =	"TAB_Owner",
  "Probe_Set" =	"TAB_Probe_Set",
  "Protocol" =	"TAB_Protocol",
  "Sequencer" =	"TAB_Sequencing_Sequencer",
  "Sequencing_Setup" =	"TAB_Sequencing_Setup",
  "Type" =	"TAB_Type",
  "Type_Group" =	"TAB_Type",
  "Worker" =	"TAB_User",
  "Index_Set" = "TAB_Index_Set",
  "P5_Index_Id" =	"TAB_Index_Set_P5",
  "P7_Index_Id" =	"TAB_Index_Set_P7"
)

usethis::use_data(auxtablelookup)

## Table with 'ID' column to the corresponding 'Name' (string) map 

id_2_name_map <- c(
  TAB_Site = "Full_Site_Id",
  TAB_Individual = "Full_Individual_Id",
  TAB_Sample = "Full_Sample_Id",
  TAB_Extract = "Full_Extract_Id",
  TAB_Library = "Full_Library_Id",
  TAB_Capture  = "Full_Capture_Id",
  TAB_Sequencing = "Full_Sequencing_Id",
  TAB_Raw_Data = "Full_Raw_Data_Id",
  TAB_Sequencing = "Name",
  TAB_Tag = "Name",
  TAB_Project = "Name",
  TAB_User = "Name",
  TAB_Batch = "Name",
  TAB_Index_Set = "Name",
  TAB_Location = "Name",
  TAB_Location_Room = "Name",
  TAB_Organism = "Name",
  TAB_Owner = "Name",
  TAB_Probe_Set = "Name",
  TAB_Protocol = "Name",
  TAB_Sequencing_Sequencer = "Name",
  TAB_Sequencing_Setup = "Name",
  TAB_Type = "Name",
  TAB_Index_Set = "Name", 
  TAB_Index_Set_P5 = "Index",
  TAB_Index_Set_P7 = "Index"
)

usethis::use_data(id_2_name_map)

