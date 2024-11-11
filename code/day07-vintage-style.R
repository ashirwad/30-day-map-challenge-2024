tmp_dir <- fs::dir_create(fs::file_temp())

unzip(
  here::here("data", "IA_Ames_174058_1912_62500_geo_tif.zip"),
  exdir = tmp_dir
)

ames_1912 <- raster::brick(
  fs::path(tmp_dir, "IA_Ames_174058_1912_62500_geo.tif")
)

ames_1912_map <- mapview::viewRGB(
  ames_1912,
  r = 1, g = 2, b = 3, maxpixels = 5e6, layer.name = "Ames in 1912"
)

htmlwidgets::saveWidget(
  ames_1912_map@map, here::here("maps", "day07-vintage-style.html"),
  selfcontained = FALSE
)
