query_url <- "https://gissor.iowadot.gov/agshost/rest/services/Traffic_Safety/Crash_Data/FeatureServer/0/query?where=CITY_NAME%20%3D%20'AMES'&outFields=YCOORD,XCOORD,CRASH_DATETIME&returnGeometry=false&outSR=4326&f=json"

crash_data <- httr2::request(query_url) |>
  httr2::req_perform() |>
  httr2::resp_body_json() |>
  purrr::pluck("features") |>
  purrr::map(~ tibble::as_tibble(purrr::pluck(.x, "attributes"))) |>
  purrr::list_rbind()

crash_data_clean <- crash_data |>
  janitor::clean_names() |>
  dplyr::mutate(
    crash_datetime = lubridate::as_datetime(crash_datetime / 10^3, tz = "America/Chicago"),
    crash_month = lubridate::month(crash_datetime)
  ) |>
  sf::st_as_sf(coords = c("xcoord", "ycoord"), crs = 26915) |>
  sf::st_transform(4326)

sf::st_write(
  crash_data_clean, here::here("data", "ames-crashes-2019-2021.csv"),
  layer_options = "GEOMETRY=AS_XY"
)
