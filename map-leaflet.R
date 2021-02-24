library(leaflet)


# Provincies in EPSG:4326 (lon-at) crs
url <- 'https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&srsName=EPSG:4326&service=WFS&version=2.0.0&typeName=cbs_provincie_2020_gegeneraliseerd&outputFormat=json'
geojson <- rjson::fromJSON(file=url)

# make fake data
df <- data.frame(statnaam = rep(NA, geojson$totalFeatures),
                 consumption = rep(NA, geojson$totalFeatures))

for (i in c(1:geojson$totalFeatures)) {
  df$statnaam[i] <- geojson$features[[i]]$properties$statnaam
  df$consumption[i] <- sample(1:1000, 1)
}

bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
pal <- colorBin("YlOrRd", domain = df$consumption, bins = bins)

# make map centre is geographical centre of NL: Lunteren
m <- leaflet() %>%
  setView(lat = 52.087222, 
          lng = 5.621944,
          zoom = 7) %>%
  addTiles()


for (i in c(1:geojson$totalFeatures)) {
  m <- m %>% addGeoJSON(geojson = geojson$features[[i]]$geometry,
                        color = pal(df$consumption[[i]]))
}


m %>% addLegend(pal = pal, values = df$consumption, opacity = 0.7, title = "Energy consumption",
            position = "bottomright")

# Gemeenten in EPSG:4326 (lon-at) crs
url <- 'https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&srsName=EPSG:4326&service=WFS&version=2.0.0&typeName=cbs_gemeente_2020_gegeneraliseerd&outputFormat=json'
geojson <- rjson::fromJSON(file=url)

# make fake data
df <- data.frame(statnaam = rep(NA, geojson$totalFeatures),
                 consumption = rep(NA, geojson$totalFeatures))

for (i in c(1:geojson$totalFeatures)) {
  df$statnaam[i] <- geojson$features[[i]]$properties$statnaam
  df$consumption[i] <- sample(1:1000, 1)
}

bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
pal <- colorBin("YlOrRd", domain = df$consumption, bins = bins)



# make map centre is geographical centre of NL: Lunteren
m <- leaflet() %>%
  setView(lat = 52.087222, 
          lng = 5.621944,
          zoom = 7) %>%
  addTiles()


for (i in c(1:geojson$totalFeatures)) {
  m <- m %>% addGeoJSON(geojson = geojson$features[[i]]$geometry,
                        color = pal(df$consumption[[i]]))
}


m <- m %>% addLegend(pal = pal, values = df$consumption, opacity = 0.7, title = "Energy consumption",
                position = "bottomright")

m

