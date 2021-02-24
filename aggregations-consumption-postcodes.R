postcodes <- read.csv("./data-out/postcodes.csv")
postcodes <- postcodes[, c("Postcode", "Gemeente", "Provincie" )]
names(postcodes)

consumtion <- read.csv("./data-out/list-of-aggregates.csv")

consumtion <- merge(consumtion, postcodes)


write.csv(consumtion, "./data-out/list-of-aggregates-postcodes.csv", row.names = F)