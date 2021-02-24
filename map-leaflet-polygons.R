library(leaflet)

# Provincies in EPSG:4326 (lon-at) crs
url <- 'https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&srsName=EPSG:4326&service=WFS&version=2.0.0&typeName=cbs_provincie_2020_gegeneraliseerd&outputFormat=json'
geojson <- rjson::fromJSON(file = url)
geojson <- rjson::toJSON(geojson)
write(geojson, "./data-out/provincie_2020.geojson")
geojson <- geojsonio::geojson_read("./data-out/provincie_2020.geojson", what = "sp")
# make fake data
df <- data.frame(statnaam = geojson$statnaam,
                 consumption = sample(1:1000, length(geojson$statnaam)))


bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
pal <- colorBin("YlOrRd", domain = df$consumption, bins = bins)

labels <- sprintf(
  "<strong>%s</strong><br/>Consumption: %g ",
  df$statnaam, df$consumption
) %>% lapply(htmltools::HTML)

leaflet(geojson) %>%
  setView(lat = 52.087222, 
          lng = 5.621944,
          zoom = 7) %>%
  addTiles() %>%
#  addProviderTiles("MapBox", options = providerTileOptions(
#    id = "mapbox.light",
#    accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) %>%
  addPolygons(
    fillColor = pal(df$consumption),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    highlight = highlightOptions(
      weight = 5,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE),
    label = labels,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto")) %>%
  addLegend(pal = pal, values = df$consumption, opacity = 0.7, title = "Energy consumtion",
            position = "bottomright")

# Gemeenten in EPSG:4326 (lon-at) crs
url <- 'https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&srsName=EPSG:4326&service=WFS&version=2.0.0&typeName=cbs_gemeente_2020_gegeneraliseerd&outputFormat=json'
geojson <- rjson::fromJSON(file = url)
geojson <- rjson::toJSON(geojson)
write(geojson, "./data-out/gemeente_2020.geojson")
geojson <- geojsonio::geojson_read("./data-out/gemeente_2020.geojson", what = "sp")
# make fake data
df <- data.frame(statnaam = geojson$statnaam,
                 consumption = sample(1:1000, length(geojson$statnaam)))


bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
pal <- colorBin("YlOrRd", domain = df$consumption, bins = bins)

labels <- sprintf(
  "<strong>%s</strong><br/>Consumption: %g ",
  df$statnaam, df$consumption
) %>% lapply(htmltools::HTML)

leaflet(geojson) %>%
  setView(lat = 52.087222, 
          lng = 5.621944,
          zoom = 7) %>%
  addTiles() %>%
  #  addProviderTiles("MapBox", options = providerTileOptions(
  #    id = "mapbox.light",
  #    accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) %>%
  addPolygons(
    fillColor = pal(df$consumption),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    highlight = highlightOptions(
      weight = 5,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE),
    label = labels,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto")) %>%
  addLegend(pal = pal, values = df$consumption, opacity = 0.7, title = "Energy consumtion",
            position = "bottomright")


