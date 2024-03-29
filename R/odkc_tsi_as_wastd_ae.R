#' Transform odkc_data$tsi into WAStD AnimalEncounters.
#'
#' @param data The tibble of Turtle Sightings,
#'   e.g. \code{odkc_data$tsi}.
#' @template param-usermapping
#' @return A tibble suitable to
#'   \code{\link{wastd_POST}("animal-encounters")}
#' @export
#' @examples
#' \dontrun{
#' data("odkc_data", package = "wastdr")
#' user_mapping <- NULL # see odkc_plan for actual user mapping
#' ae <- odkc_tsi_as_wastd_ae(odkc_ex$tsi, user_mapping)
#'
#' ae %>%
#'   wastd_POST("animal-encounters",
#'     api_url = Sys.getenv("WASTDR_API_DEV_URL"),
#'     api_token = Sys.getenv("WASTDR_API_DEV_TOKEN")
#'   )
#' }
odkc_tsi_as_wastd_ae <- function(data, user_mapping) {
  wastd_reporters <- user_mapping %>%
    dplyr::transmute(reporter = odkc_username, reporter_id = pk)

  wastd_observers <- user_mapping %>%
    dplyr::transmute(observer = odkc_username, observer_id = pk)

  data %>%
    wastdr::sf_as_tbl() %>%
    dplyr::transmute(
      source = "odk", # wastd.observations.models.SOURCE_CHOICES
      source_id = id,
      observer = reporter %>%
        stringr::str_squish() %>%
        stringr::str_to_lower(),
      reporter = observer,
      comments = glue::glue(
        "Device ID {device_id}\n",
        "Observer activity: {encounter_observer_acticity}\n",
        "Form filled in from {observation_start_time} to ",
        "{observation_end_time}\n"
      ),
      where = glue::glue(
        "POINT ({encounter_observed_at_longitude}",
        " {encounter_observed_at_latitude})"
      ),
      location_accuracy = "10",
      location_accuracy_m = encounter_observed_at_accuracy,
      when = lubridate::format_ISO8601(observation_start_time, usetz = TRUE),
      taxon = "Cheloniidae",
      health = "alive",
      species = encounter_species %>% tidyr::replace_na("na"),
      sex = encounter_sex %>% tidyr::replace_na("na"),
      maturity = encounter_maturity %>% tidyr::replace_na("na"),
      activity = encounter_activity %>% tidyr::replace_na("na")
    ) %>%
    dplyr::left_join(wastd_reporters, by = "reporter") %>% # wastd User PK
    dplyr::left_join(wastd_observers, by = "observer") %>% # wastd User PK
    dplyr::select(-reporter, -observer) %>%
    invisible()
}

# usethis::use_test("odkc_tsi_as_wastd_ae")
