col_names <- names(
  readr::read_csv(here::here("data", "us-airports.csv"), n_max = 0)
)
ia_airports <- readr::read_csv(
  here::here("data", "us-airports.csv"),
  col_names = col_names, skip = 2
) |>
  dplyr::filter(region_name == "Iowa", type != "closed")

readr::write_csv(ia_airports, here::here("data", "ia-airports-hdx.csv"))
