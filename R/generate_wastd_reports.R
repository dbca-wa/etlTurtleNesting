#' Generate reports from WAStD turtle data
#'
#' @param wastd_data The output of `wastdr::download_wastd_turtledata()`.
#' @export
#' @examples
#' \dontrun{
#' drake::loadd("wastd_data")
#'
#' # Compile all reports
#' etlTurtleNesting::generate_wastd_reports(wastd_data)
#'
#' # Compile one single report
#' rmarkdown::render(
#'   here::here("vignettes/wastd.Rmd"),
#'   params = list(area_name = "Delambre Island"),
#'   output_file = here::here("vignettes/wastd_del.html")
#' )
#' }
generate_wastd_reports <- function(wastd_data) {
  # save wastd_data.rds
  saveRDS(wastd_data, file = here::here("vignettes", "wastd_data.rds"))

  # # Overview dashboard
  # a <- "wa_overview"
  # fn <- here::here("vignettes", glue::glue("{wastdr::urlize(a)}.html"))
  # wastdr::wastdr_msg_info(glue::glue("Rendering report for {a} to {fn}..."))
  # rmarkdown::render(
  #   here::here("vignettes/wa_overview.Rmd"),
  #   params = list(wastd_data = "Delambre Island"),
  #   output_file = fn
  # )
  # wastdr::wastdr_msg_success(glue::glue("Compiled {fn}."))

  # Delambre RIO report
  # Add other tagging reports here
  # a <- "del_rio"
  # fn <- here::here("vignettes", glue::glue("{wastdr::urlize(a)}.html"))
  # wastdr::wastdr_msg_info(glue::glue("Rendering report for {a} to {fn}..."))
  # rmarkdown::render(
  #   here::here("vignettes/del_rio.Rmd"),
  #   params = list(
  #     area_name = "Delambre Island",
  #     prefix = "DEL",
  #     w2_filepath = "inst/data/wamtram.csv",
  #     w2_initial_rookery_code = "DA",
  #     w2_place_code = "DADI",
  #     w2_exported_on = "20 Sept 2021",
  #     export_dir = "inst/reports/rio"
  #   ),
  #   output_file = fn
  # )
  # wastdr::wastdr_msg_success(glue::glue("Compiled {fn}."))

  # WAStD only reports - compile
  for (a in c(unique(wastd_data$areas$area_name), "Other")) {
    fn <- here::here("vignettes", glue::glue("{wastdr::urlize(a)}.html"))
    wastdr::wastdr_msg_info(glue::glue("Rendering report for {a} to {fn}..."))
    rmarkdown::render(
      here::here("vignettes/wastd.Rmd"),
      params = list(area_name = a),
      output_file = fn
    )
    wastdr::wastdr_msg_success(glue::glue("Compiled {fn}."))
  }

  # All reports - copy
  fs::dir_ls(here::here("vignettes"), glob = "*.html") %>%
    fs::file_copy(here::here("inst/reports/"), overwrite = TRUE)
  wastdr::wastdr_msg_success("Copied reports to inst/reports.")

  fs::dir_ls(here::here("inst/reports/"), glob = "*.html")
}
