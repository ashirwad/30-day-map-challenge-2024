ames_routes <- readr::read_csv(
  here::here("data", "jefferson-lines-ames-routes-2024.csv")
)

ames_routes_geocoded <- ames_routes |>
  tidygeocoder::geocode(
    address = origin, method = "arcgis", lat = "orig_lat", lon = "orig_lon"
  ) |>
  tidygeocoder::geocode(
    address = dest, method = "arcgis", lat = "dest_lat", lon = "dest_lon"
  )

ames_routes_geocoded |>
  readr::write_csv(
    here::here("data", "jefferson-lines-ames-routes-2024-geocoded.csv")
  )
