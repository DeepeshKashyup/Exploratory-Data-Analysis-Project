

#load packages
library(dplyr)
library(ggplot2)
#Code to download and unzip the data file
url <-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if(!file.exists("Source_Classification_Code.rds")){
    temp <- tempfile()
    download.file(url,temp)
    f<- unzip(temp)
    unlink(temp)
}

#code to read RDS Files 
pm <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

#code to filter data on fips , grouped data on year and computed sum of Particulate matter on year
pm2 <- pm %>% filter(fips == "24510")%>% select(year,Emissions) %>%group_by(year) %>% summarise(Emissions =sum(Emissions))
pm2$Emissions <- round(pm2$Emissions/1000,2)

png(filename='./plot2.png')
barplot(pm2$Emissions,ylab=expression("PM"[2.5]),names.arg = pm1$year,main="Total Emission in Baltimore city,MD")

dev.off()