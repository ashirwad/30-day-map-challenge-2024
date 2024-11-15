import_seaice_extent <- function(url) {
  tmp_file <- fs::file_temp(ext = "zip")
  download.file(url, tmp_file, quiet = TRUE)

  sf::read_sf(fs::path("/vsizip", tmp_file))
}

month_info <- tibble::tibble(
  month = month.abb,
  month_num = stringr::str_pad(1:12, width = 2, pad = "0")
)

seaice_extent_df <- tibble::tibble(
  year = 2023,
  month = month.abb
) |>
  dplyr::left_join(month_info, by = "month") |>
  dplyr::mutate(
    url = glue::glue(
      "https://noaadata.apps.nsidc.org/NOAA/G02135/north/monthly/shapefiles/shp_extent/{month_num}_{month}/extent_N_{year}{month_num}_polygon_v3.0.zip"
    ),
    seaice_extent = purrr::map(
      url, ~ import_seaice_extent(.x) |> sf::st_transform(3411)
    ),
    month = factor(month, levels = month.abb)
  ) |>
  tidyr::unnest(seaice_extent) |>
  sf::st_as_sf()

seaice_extent_plot <- ggplot2::ggplot(seaice_extent_df) +
  ggplot2::geom_sf(fill = "#E0FFFF", alpha = 0.7) +
  ggplot2::coord_sf(expand = FALSE) +
  ggplot2::labs(
    title = "Monthly variations in Arctic Sea Ice Extent",
    subtitle = "{closest_state} 2023"
  ) +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(size = 28),
    plot.subtitle = ggplot2::element_text(size = 24),
    axis.text = ggplot2::element_text(size = 20)
  ) +
  gganimate::transition_states(
    month,
    state_length = 4, transition_length = 3, wrap = FALSE
  ) +
  gganimate::ease_aes("cubic-in-out")

seaice_extent_anim <- gganimate::animate(
  seaice_extent_plot, width = 1600, height = 1200
)

gganimate::anim_save(
  filename = "day11-arctic.gif",
  animation = seaice_extent_anim,
  path = here::here("map-previews")
)
