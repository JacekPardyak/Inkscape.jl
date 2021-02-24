library(tidyr)
postcodes <- read.csv("./data-out/postcodes.csv")
files <- read.csv("./data-out/list-of-files.csv", stringsAsFactors = F)
files <- files[!is.na(files$file),]


res <- data.frame()
for (i in c(1:150)) {
#i = 1
    print(i)
  year = files$year[i]
  type = files$type[i]
  company = files$company[i]
  file = files$file[i]
  
  data <- read.csv(unz("./data-in/archive.zip", file), stringsAsFactors = F)
  data$Postcode <- substr(data$zipcode_from, 1, 4)
  data <- data[, c("Postcode", "annual_consume")]
  data$Postcode[!(data$Postcode %in% postcodes$Postcode)] <- NA # wrong postcode
  data$Postcode[data$Postcode == 0] <- NA # postcode 0
  data <-  fill(data, "Postcode") # fill with next value
  tmp <- aggregate(data$annual_consume, by=list(Postcode=data$Postcode), FUN=sum)
  names(tmp)  <-  c("Postcode", "annual_consume")
  row = data.frame(year, type)
  tmp = cbind(tmp, row)
  
  res = rbind(res, tmp)
#  print(paste("# NA   :", sum(is.na(tmp$Postcode))))
#  print(paste("# 0    :", sum(tmp$Postcode == 0)))
#  print(paste("# wrong:", sum(!(tmp$Postcode %in% postcodes$Postcode))))
}

write.csv(res, "./data-out/list-of-aggregates.csv", row.names = F)

