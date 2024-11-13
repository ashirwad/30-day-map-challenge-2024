isu_map_slide_view <- slideview::slideview(
  here::here("images", "isu-campus-map-online.png"),
  here::here("images", "isu-campus-map-stable-diffusion.png"),
  "Actual", "AI Generated"
)

htmlwidgets::saveWidget(
  isu_map_slide_view, here::here("maps", "day09-ai.html"),
  selfcontained = FALSE
)
