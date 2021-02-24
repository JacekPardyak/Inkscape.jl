# load packages
library(rvest)
library(dplyr)
library(data.table)

# list all postcodes in the data
files <-  unzip(zipfile = "./archive.zip", list = TRUE)$Name
postcodes <- c()
for (file in files) {
  data <- read.csv(unz("./archive.zip", file), stringsAsFactors = F)
  zipcode_from <- substr(data$zipcode_from, 1, 4)
  zipcode_to <- substr(data$zipcode_to, 1, 4)
  zipcode_uni <- union(zipcode_from, zipcode_to)
  postcodes <- union(postcodes, zipcode_uni)
}

# with try catch

res = data.table()
count = 0
for (postcode in postcodes) { # not found 640, 
  tryCatch({
  count = count+1
  print(paste(count, postcode))
  url <- paste("https://postcodebijadres.nl/", postcode, sep = "")
  
  html <- url %>% read_html()
  html %>%
    html_nodes(xpath = "/html/body/main/div/div[1]/section[1]/table") %>%
    html_table() %>%
    `[[`(1) %>%
    `rownames<-`(.[,1]) %>%
    select(-X1) %>%
    t() %>%
    as.data.table() -> tbl.1
  
  html %>%
    html_nodes(xpath = "/html/body/main/div/div[2]/section[2]/table") %>%
    html_table() %>%
    `[[`(1) %>%
    `rownames<-`(.[,1]) %>%
    select(-X1) %>%
    t() %>%
    as.data.table() -> tbl.2
  
  tbl <- cbind(tbl.1, tbl.2)
  res <- rbind(res, tbl, fill = TRUE)
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}

write.csv(res, "./data-out/postcodes.csv", row.names = F)



