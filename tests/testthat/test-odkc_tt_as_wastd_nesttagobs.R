test_that("odkc_tt_as_wastd_nesttagobs works", {
  data("odkc_data", package = "wastdr")
  data("wastd_data", package = "wastdr")

  odkc_names <- odkc_data$tt %>%
    odkc_tt_as_wastd_nesttagobs() %>%
    dplyr::select(-source, -source_id) %>%
    names()

  # ODKC data transformed into WAStD shape should contain all fields of the
  # WAStD serializer
  for (n in odkc_names) {
    testthat::expect_true(
      n %in% names(wastd_data$nest_tags),
      label = glue::glue("Column \"{n}\" exists in wastd_data$nest_tags")
    )
  }
})
