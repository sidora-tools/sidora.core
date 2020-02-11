## Note: Robot and Ethically_culturally_senstive is actually character as 
## Yes/No, but we should convert it to boolean
coltypes_common <- list("Id" = as.integer,
                        "Worker" = as.integer,
                        "Creation_Date" = as.Date,
                        "Files" = as.integer,
                        "Notes" = as.character,
                        "Tags" = as.character,
                        "Projects" = as.character,
                        "Deleted" = as.logical,
                        "Deleted_Date" = as.Date,
                        "Protocol" = as.integer,
                        "Experiment_Date" = as.Date,
                        "Batch" = as.integer,
                        "Contact_Person" = as.character,
                        "Ethically_culturally_sensitive" = as.logical,
                        "Robot" = as.logical,
                        "Position_on_Plate" = as.character,
                        "Location_Room" = as.character,
                        "Location" = as.character
                        )

coltypes_site <- c(coltypes_common, 
                   list(
                      "Site_Id" = as.character,
                      "Full_Site_Id" = as.character,
                      "Name" = as.character,
                      "Locality" = as.character,
                      "Province" = as.character,
                      "Country" = as.character,
                      "Latitude" = as.double,
                      "Longitude" = as.double
                      )
                   )

coltypes_individual <- c(coltypes_common, 
                         list(
                           "Site" = as.integer,
                           "Individual_Id" = as.integer,
                           "Full_Individual_Id" = as.character,
                           "Owning_institution" = as.character,
                           "Provenience" = as.character,
                           "Organism" = as.integer,
                           "Archaeological_ID" = as.character,
                           "C14_Uncalibrated" = as.integer,
                           "C14_Uncalibrated_Variation" = as.integer,
                           "C14_Calibrated_From" = as.integer,
                           "C14_Calibrated_To" = as.integer,
                           "C14_Info" = as.character,
                           "C14_Id" = as.character,
                           "Ethics" = as.character
                           )
                         )

coltypes_sample <- c(coltypes_common, 
                         list(
                           "Individual" = as.integer,
                           "Sample_Id" = as.character,
                           "Full_Sample_Id" = as.character,
                           "Archaeological_ID" = as.integer,
                           "Type_Group" = as.integer,
                           "Type" = as.integer,
                           "Sampled_Quantity" = as.double,
                           "Location_Bone_Room" = as.integer,
                           "Location_Bone" = as.integer,
                           "Location_Powder_Room" = as.integer,
                           "Location_Powder" = as.integer,
                         )
                      )


coltypes_extract <- c(coltypes_common, 
                     list(
                       "Sample" = as.integer,
                       "Extract_Id" = as.character,
                       "Full_Extract_Id" = as.character,
                       "Quantity_Sample" = as.double,
                       "Quantity_Lysate" = as.double,
                       "Sampled_Quantity" = as.double,
                     )
)
