

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

MD.onroad <- subset(pm,fips=="24510" & type == "ON-ROAD")
LA.onroad <- subset(pm,fips=="06037" & type == "ON-ROAD")
MD.onroad <- mutate(MD.onroad,city="MD")
LA.onroad <- mutate(LA.onroad,city="LA")
MD <- MD.onroad %>% select(year,Emissions,city) %>%group_by(year,city)%>%summarise(sum=sum(Emissions))
LA <- LA.onroad %>% select(year,Emissions,city) %>%group_by(year,city)%>%summarise(sum=sum(Emissions))
cm <- as.data.frame(rbind(MD,LA))
png(filename='./plot6.png')
p<-ggplot(data=cm, aes(x=year,y=sum))+geom_bar(aes(fill=year),stat="identity") + facet_grid(".~city") + ggtitle("Total Emissions of Motor Vehicle Sources\nLos Angeles County,California vs. Baltimore City,Maryland") + guides(Fill="F") + ylab(expression("PM"[2.5])) + xlab("Year") + theme(legend.position = "none")+geom_text(aes(label=round(sum,0),size =1,hjust=0.5,vjust=-1))
print(p)
dev.off()