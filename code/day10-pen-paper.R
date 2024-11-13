ames_boundary <- tigris::places(state = "IA", cb = TRUE, year = 2020) |>
  dplyr::filter(NAME == "Ames")

zctas_ames <- tigris::zctas(cb = TRUE, year = 2020) |>
  sf::st_filter(ames_boundary, .predicate = sf::st_intersects)

zctas_ames_prepped <- zctas_ames |>
  sf::st_cast("POLYGON", warn = FALSE) |>
  dplyr::mutate(
    fill = c("#ac92eb", "#4fc1e8", "#4fc1e8", "#a0d568", "#ffce54", "#ed5564"),
    stroke = 1,
    fillweight = 0.5
  )

zctas_ames_sketch <- roughsf::roughsf(
  zctas_ames_prepped,
  title = "ZIP Codes covering Ames, IA",
  title_font = "48px Pristina"
)

htmlwidgets::saveWidget(
  zctas_ames_sketch, here::here("maps", "day10-pen-paper.html"),
  selfcontained = FALSE
)
