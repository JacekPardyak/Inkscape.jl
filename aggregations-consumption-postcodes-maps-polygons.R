# Gemeenten in EPSG:4326 (lon-at) crs
geojson <- geojsonio::geojson_read("./data-out/gemeente_2020.geojson", what = "sp")

consumtion <- read.csv("./data-out/list-of-aggregates-postcodes.csv", stringsAsFactors = F)

consumtion.gemeente <- aggregate(consumtion$annual_consume, 
                                 by = list(consumtion$year,
                                           consumtion$type,
                                           consumtion$Gemeente), FUN=sum)
names(consumtion.gemeente) <- c("year", "type", "statnaam", "consumption")


df <- consumtion.gemeente[consumtion.gemeente$year == 2019 & 
                            consumtion.gemeente$type == "electricity",
                          c("statnaam", "consumption")]

keys <- geojson$statnaam
keyDF <- data.frame(key = keys, weight=1:length(keys))

df <- merge(df, keyDF, by.x='statnaam',by.y='key',all.x=T,all.y=F)
df <- df[order(df$weight), c("statnaam", "consumption")]

bins <- c(quantile(df$consumption))
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





# Provincies in EPSG:4326 (lon-at) crs
geojson <- geojsonio::geojson_read("./data-out/provincie_2020.geojson", what = "sp")

consumtion.provincie <- aggregate(consumtion$annual_consume, 
                                 by = list(consumtion$year,
                                           consumtion$type,
                                           consumtion$Provincie), FUN=sum)
names(consumtion.provincie) <- c("year", "type", "statnaam", "consumption")


df <- consumtion.provincie[consumtion.provincie$year == 2019 & consumtion.provincie$type == "electricity",
                           c("statnaam", "consumption")]

keys <- geojson$statnaam
keyDF <- data.frame(key = keys, weight=1:length(keys))

df <- merge(df, keyDF, by.x='statnaam',by.y='key',all.x=T,all.y=F)
df <- df[order(df$weight), c("statnaam", "consumption")]

bins <- c(quantile(df$consumption))
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
