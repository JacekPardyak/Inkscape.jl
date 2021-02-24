library(leaflet)




urlGemeente <- 'https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&srsName=EPSG:4326&service=WFS&version=2.0.0&typeName=cbs_gemeente_2020_gegeneraliseerd&outputFormat=json'
geojsonGemeente <- rjson::fromJSON(file = urlGemeente)

urlProvincie <- 'https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&srsName=EPSG:4326&service=WFS&version=2.0.0&typeName=cbs_provincie_2020_gegeneraliseerd&outputFormat=json'
geojsonProvincie <- rjson::fromJSON(file = urlProvincie)


consumtion <- read.csv("./data-out/list-of-aggregates-postcodes.csv", stringsAsFactors = F)

consumtionGemeente <- aggregate(consumtion$annual_consume, 
                                 by = list(consumtion$year,
                                           consumtion$type,
                                           consumtion$Gemeente), FUN=sum)
names(consumtionGemeente) <- c("year", "type", "statnaam", "consumption")
consumtionProvincie <- aggregate(consumtion$annual_consume, 
                                by = list(consumtion$year,
                                          consumtion$type,
                                          consumtion$Provincie), FUN=sum)
names(consumtionProvincie) <- c("year", "type", "statnaam", "consumption")




# ----------------
my_map <- function(year, type, level){
#  year = 2020
  #type = "gas" # 
#  type = "electricity"
  #level = "Gemeente" 
#  level = "Provincie"
  
  title = toupper(paste(type, "consumtion by", level, "in", year))
  
  tmp <- get(paste("consumtion", level, sep = ""))
  
  df <- tmp[tmp$year == year &
            tmp$type == type,
            c("statnaam", "consumption")]
  geojson <- get(paste("geojson", level, sep = ""))
  
  keys <- c()
  for (i in c(1:geojson$totalFeatures)) {
    keys[[i]] <- geojson$features[[i]]$properties$statnaam
  }
  
  keyDF <- data.frame(key = keys, weight=1:length(keys))
  
  df <- merge(df, keyDF, by.x='statnaam', by.y='key', all.x = F, all.y = T)
  df$consumption[is.na(df$consumption)] = mean(df$consumption, na.rm = T)
  df <- df[order(df$weight), c("statnaam", "consumption")]
  
  bins <- c(quantile(df$consumption))
  pal <- colorBin("YlOrRd", domain = df$consumption, bins = bins)
  
  m <- leaflet() %>%
    setView(lat = 52.087222, 
            lng = 5.621944,
            zoom = 7) %>%
    addTiles()
  
  
  for (i in c(1:geojson$totalFeatures)) {
      m <- m %>% addGeoJSON(geojson = geojson$features[[i]]$geometry,
                          color = pal(df$consumption[[i]]))
  }
  
  m <- m %>% addLegend(pal = pal, values = df$consumption, opacity = 0.7, title = title,
                  position = "bottomright")
  m
}
  
my_map(year = 2010,
       #type = "gas",
       type = "electricity",
       level = "Gemeente")

my_map(year = 2020,
       #type = "gas",
       type = "electricity",
       level = "Provincie")
