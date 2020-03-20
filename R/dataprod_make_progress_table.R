#' Make an individual-based progress table
#' 
#' @param x data.frame 
#' 
#' @return data.frame progress table
#' 
#' @export
make_progress_table <- function(x) {
  x %>%
    dplyr::mutate(
      sg_sequencing_id = ifelse(.data$Probe_Set == 16, .data$Full_Sequencing_Id, NA),
      non_sg_capture_id = ifelse(.data$Probe_Set != 16, .data$Full_Capture_Id, NA),
      non_sg_sequencing_id = ifelse(.data$Probe_Set != 16, .data$Full_Sequencing_Id, NA)
    ) %>%
    dplyr::group_by(.data$Full_Individual_Id) %>%
    dplyr::summarise(
      country = dplyr::first(.data$Country),
      site_name = dplyr::first(.data$Name),
      nr_samples = dplyr::n_distinct(.data$Full_Sample_Id, na.rm = TRUE),
      nr_extracts = dplyr::n_distinct(.data$Full_Extract_Id, na.rm = TRUE),
      nr_libraries = dplyr::n_distinct(.data$Full_Library_Id, na.rm = TRUE),
      nr_shotgun_screenings = dplyr::n_distinct(.data$sg_sequencing_id, na.rm = TRUE),
      nr_captures = dplyr::n_distinct(.data$non_sg_capture_id, na.rm = TRUE),
      nr_sequencings = dplyr::n_distinct(.data$non_sg_sequencing_id, na.rm = TRUE)
    )
}
