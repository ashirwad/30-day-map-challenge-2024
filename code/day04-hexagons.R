ames_pd_charges <- readr::read_csv(
  here::here("data", "ames-pd-sep-2024-charges.csv")
) |>
  janitor::clean_names() |>
  dplyr::mutate(
    location_of_arrest = glue::glue("{location_of_arrest}, Ames, IA"),
    time = stringr::str_pad(time, width = 4, pad = "0")
  ) |>
  tidygeocoder::geocode(location_of_arrest, method = "arcgis")


ames_pd_charges |>
  readr::write_csv(here::here("data", "ames-pd-sep-2024-charges-geocoded.csv"))
