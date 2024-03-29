#' Reconstruct WAStD Surveys from ODKC Site Visit Start/End
#'
#'
#' @details Surveys are reconstructed from Site Visit Start records.
#' Survey end details are populated from Site Visit End records, where matching
#' by `device_id`, `calendar_date_awst`, and `site_id`.
#'
#' Sources of error:
#' * SVS forgotten to record
#' * SVE forgotten to record
#' * SVS recorded outside known site boundaries (WAStD Area),
#'   `site_id` mismatch, svs$site_id empty
#' * SVE recorded outside known site boundaries (WAStD Area),
#'   `site_id` mismatch, sve$site_id empty
#' * Changed devices mid survey (`device_id` mismatch, likely reporter mismatch,
#'   see end_comments)
#'
#' Things to provide as QA reports outside this function:
#' * Stray SVE without matching SVS
#' * SVS joined to SVE only by device_id and calendar_date_awst minus "good"
#'   surveys (location out of bounds)
#' * SVS joined to SVE only by calendar_date_awst and site_id minus "good"
#'   surveys (device swapped?)
#'
#'
#' @param svs ODKC Site Visit Start, e.g. `data("odkc_data"); odkc_data$svs`
#' @param sve ODKC Site Visit End, e.g. `data("odkc_data"); odkc_data$sve`
#'
#' @return A tibble in the correct format to upload as WAStD Surveys
#' @export
#'
#' @examples
#' \dontrun{
#' wastdr::wastdr_setup(
#'   api_url = Sys.getenv("WASTDR_API_DEV_URL"),
#'   api_token = Sys.getenv("WASTDR_API_DEV_TOKEN")
#' )
#' drake::loadd(odkc_ex)
#' drake::loadd(user_mapping)
#' x <- odkc_svs_sve_as_wastd_surveys(odkc_ex$svs, odkc_ex$sve, user_mapping)
#' }
odkc_svs_sve_as_wastd_surveys <- function(svs, sve, user_mapping) {
  wastd_reporters <- user_mapping %>%
    dplyr::transmute(reporter = odkc_username, reporter_id = pk)

  survey_ends <- sve %>%
    wastdr::sf_as_tbl() %>%
    dplyr::transmute(
      end_source_id = id,
      end_time = lubridate::format_ISO8601(survey_end_time, usetz = TRUE),
      survey_end_time = survey_end_time,
      end_location = glue::glue(
        "POINT ({site_visit_location_longitude}",
        " {site_visit_location_latitude})"
      ),
      end_location_accuracy_m = site_visit_location_accuracy,
      # end_photo = site_visit_site_conditions,
      end_comments = glue::glue(
        "{site_visit_comments}\n",
        "End point recorded by {reporter} ",
        "on device {device_id}."
      ),
      # for matching to svs:
      # device_id = device_id,
      # calendar_date_awst = calendar_date_awst,
      site_id = site_id
    )

  surveys <- svs %>%
    wastdr::sf_as_tbl() %>%
    dplyr::transmute(
      reporter = reporter %>%
        stringr::str_squish() %>%
        stringr::str_to_lower(),
      source = "odk", # wastd.observations.models.SOURCE_CHOICES
      source_id = id,
      device_id = device_id,
      start_location = glue::glue(
        "POINT ({site_visit_location_longitude}",
        " {site_visit_location_latitude})"
      ),
      start_location_accuracy_m = site_visit_location_accuracy,
      start_time = lubridate::format_ISO8601(datetime, usetz = TRUE),
      start_datetime = datetime,
      latest_end_time = datetime + lubridate::hours(8),
      # start_photo = site_visit_site_conditions,
      start_comments = glue::glue(
        "{site_visit_comments}\n",
        "Team: {site_visit_team}"
      ),
      production = TRUE, # SVS should have field "production/training"
      # "team" - resolve usernames?

      calendar_date_awst = calendar_date_awst,
      site_id = site_id
    ) %>%
    dplyr::left_join(wastd_reporters, by = "reporter") %>% # wastd User PK
    dplyr::left_join(survey_ends, by = "site_id") %>%
    dplyr::filter(survey_end_time > start_datetime) %>%
    dplyr::filter(survey_end_time < latest_end_time) %>%
    dplyr::select(
      -reporter,
      -calendar_date_awst,
      -site_id,
      -start_datetime,
      -latest_end_time,
      -survey_end_time
    )

  surveys
}
