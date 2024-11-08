ames_pd_charges <- readr::read_csv("data/ames-pd-sep-2024-charges.csv") |>
  janitor::clean_names() |>
  dplyr::mutate(
    location_of_arrest = glue::glue("{location_of_arrest}, Ames, IA")
  ) |>
  tidygeocoder::geocode(location_of_arrest, method = "arcgis")


ames_pd_charges |>
  readr::write_csv("data/ames-pd-sep-2024-charges-geocoded.csv")
