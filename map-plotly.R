library(plotly)
library(rjson)



# Provincies in EPSG:4326 (lon-at) crs

url <- 'https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&srsName=EPSG:4326&service=WFS&version=2.0.0&typeName=cbs_provincie_2020_gegeneraliseerd&outputFormat=json'
geojson <- rjson::fromJSON(file=url)

df <- data.frame(statnaam = rep(NA, geojson$totalFeatures),
                 consumption = rep(NA, geojson$totalFeatures))

for (i in c(1:geojson$totalFeatures)) {
  df$statnaam[i] <- geojson$features[[i]]$properties$statnaam
  df$consumption[i] <- sample(1:1000, 1)
}

g <- list(
  fitbounds = "locations",
  visible = TRUE
)

fig <- plot_ly() 
fig <- fig %>% add_trace(
  type = "choropleth",
  geojson = geojson,
  locations = df$statnaam,
  z=df$consumption,
  #  colorscale="Viridis",
  featureidkey="properties.statnaam"
)
fig <- fig %>% layout(
  geo = g
)
fig <- fig %>% colorbar(title = "Energy consumption")
fig <- fig %>% layout(
  title = "Energy consumption of the Netherlands"
)
fig


