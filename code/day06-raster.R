ames_boundary <- tigris::places(state = "IA", cb = TRUE, year = 2020) |>
  dplyr::filter(NAME == "Ames")

ames_elevation <- elevatr::get_elev_raster(
  locations = ames_boundary, z = 9, clip = "locations"
)

ames_elevation_map <- mapview::mapview(
  ames_elevation,
  layer.name = "Elevation (meters)"
)

htmlwidgets::saveWidget(
  ames_elevation_map@map, here::here("maps", "day06-raster.html"),
  selfcontained = FALSE
)
