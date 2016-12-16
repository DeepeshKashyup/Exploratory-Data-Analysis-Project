

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

scc_ms <- scc[scc$Data.Category=="Onroad",]
scc_ms<-select(scc_ms,SCC,SCC.Level.Four)
pm.bl <- filter(pm,fips == "24510" & type=="ON-ROAD")
bl.ms <- merge (pm.bl,scc_ms,by="SCC")
bl.ms.em <- bl.ms %>% select(year,Emissions) %>% group_by(year)%>% summarise(sum=sum(Emissions))
bl.ms.em$year <- factor(bl.ms.em$year, levels=c('1999', '2002', '2005', '2008'))

png(filename='./plot5.png')

g<- ggplot(data =bl.ms.em,aes(x=year,y=sum))+geom_bar(stat="identity",aes(fill=year))+ggtitle("Total Emission of Motor Vehicle Sources in Baltimore,Maryland") + ylab(expression("PM"[2.5])) +xlab('Year')+geom_text(aes(label=round(sum,0),size=1,hjust=0.5,vjust=2))+theme(legend.position = "none")

print(g)
dev.off()