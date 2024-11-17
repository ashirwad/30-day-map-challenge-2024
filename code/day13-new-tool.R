ames_boundary <- tigris::places(state = "IA", cb = TRUE, year = 2020) |>
  dplyr::filter(NAME == "Ames")

# Adapted from: https://walker-data.com/mapgl/articles/map-design.html
ames_age <- tidycensus::get_acs(
  geography = "tract",
  variables = "B01002_001",
  state = "IA",
  county = "Story",
  year = 2022,
  geometry = TRUE
) |>
  sf::st_filter(ames_boundary, .predicate = sf::st_intersects) |>
  dplyr::mutate(
    popup = glue::glue(
      "<strong>GEOID: </strong>{GEOID}<br><strong>Median age: </strong>{estimate}"
    )
  )

ames_map_cont_style <- mapgl::mapboxgl(
  mapgl::mapbox_style("light"),
  bounds = ames_age
) |>
  mapgl::add_fill_layer(
    id = "ames_tracts",
    source = ames_age,
    fill_color = mapgl::interpolate(
      column = "estimate",
      values = c(15, 50),
      stops = c("lightblue", "darkblue"),
      na_color = "lightgrey"
    ),
    fill_opacity = 0.5,
    popup = "popup",
    tooltip = "estimate",
    hover_options = list(
      fill_color = "yellow",
      fill_opacity = 0.5
    )
  ) |>
  mapgl::add_legend(
    "Median age in Ames, IA",
    values = c(15, 50),
    colors = c("lightblue", "darkblue")
  )

brewer_pal <- RColorBrewer::brewer.pal(6, "RdYlBu")

ames_map_cat_style <- mapgl::mapboxgl(
  mapgl::mapbox_style("light"),
  bounds = ames_age
) |>
  mapgl::add_fill_layer(
    id = "ames_tracts",
    source = ames_age,
    fill_color = mapgl::step_expr(
      column = "estimate",
      base = brewer_pal[1],
      stops = brewer_pal[2:6],
      values = seq(20, 40, 5),
      na_color = "white"
    ),
    fill_opacity = 0.5,
    popup = "popup",
    tooltip = "estimate",
    hover_options = list(
      fill_color = "yellow",
      fill_opacity = 0.5
    )
  ) |>
  mapgl::add_legend(
    "Median age in Ames, IA",
    values = c(
      "Under 20",
      "20-25",
      "25-30",
      "30-35",
      "35-40",
      "Above 40"
    ),
    position = "top-right",
    colors = brewer_pal,
    type = "categorical"
  )

ames_swipe_map <- mapgl::compare(ames_map_cont_style, ames_map_cat_style)

htmlwidgets::saveWidget(
  ames_swipe_map, here::here("maps", "day13-new-tool.html"),
  selfcontained = FALSE
)
