

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

#code to read RDS files
pm <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

#code to filter on fips and select year ,emission and type columns
pm3 <- pm %>% filter(fips == "24510")%>% select(year,Emissions,type)
pm3$year <- factor(pm3$year, levels=c('1999', '2002', '2005', '2008'))
pm3$type <- as.factor(pm3$type)
pm3 <- group_by(pm3,type,year)

pm3_sum <- summarise(pm3,sum= sum(Emissions))

png(filename='./plot3.png')
g <- ggplot(pm3_sum,aes(year,log(sum))) + geom_bar(stat="identity",aes(fill=type)) + facet_grid(.~type) + labs(title= "Emission per type in Baltimore city,MD", y="Emission") + theme(legend.position = "none")
print(g)
dev.off()