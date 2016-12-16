

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

pm <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

pm1 <- pm %>% select(year,Emissions) %>% group_by(year) %>% summarise(Emissions =sum(Emissions))
pm1$Emissions <- round(pm1$Emissions/1000,2)

png(filename='./plot1.png')

barplot(pm1$Emissions,ylab=expression("PM"[2.5]),names.arg = pm1$year,main=expression("Total Emission of PM"[2.5]))

dev.off()