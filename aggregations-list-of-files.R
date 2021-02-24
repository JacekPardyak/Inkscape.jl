files <-  unzip(zipfile = "./data-in/archive.zip", list = TRUE)$Name # 150 files

files <- gsub("enduris", "enduris_", files)

years <- c(
  "2009",
  "2010",
  "2011",
  "2012",
  "2013",
  "2014",
  "2015",
  "2016",
  "2017",
  "2018",
  "2019",
  "2020")
companies <- c(
"Enexis",
"Endinet",
"Liander",
"Stedin",
"Enduris",
"Westland-infra",
"Rendo",
"Coteq")

types <- c(
  "gas",
  "electricity")

#require(data.table)
res <- data.frame()
for (year in years) {
  sub_years <- files[grepl(pattern = year, x = files, ignore.case = T)]
  for (company in companies) {
    sub_companies <- sub_years[grepl(pattern = company, x = sub_years, ignore.case = T)]
    for (type in types) {
      file <- sub_companies[grepl(pattern = type, x = sub_companies, ignore.case = T)]
      tmp <- data.frame(year = year,
                        company = company,
                        type = type,
                        file = ifelse(length(file) ==0, NA, file))
      res <- rbind(res, tmp)
      
    }
  }
}

res$file <- gsub("enduris_", "enduris", res$file)

write.csv(res, "./data-out/list-of-files.csv", row.names = F)
