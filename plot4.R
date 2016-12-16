

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
combust <- grep("Combustion",scc$SCC.Level.One)
coal <- grep("Coal",scc$SCC.Level.Four)
cc <- intersect(combust,coal)
scc_cc <- select(scc[cc,],SCC,Short.Name)
pm_scc <- merge(pm,scc_cc,by="SCC")
pm_cc <- pm_scc%>% select(year,Emissions) %>% group_by(year)%>%summarise(Emissions=sum(Emissions))

pm_cc$Emissions <- round(pm_cc$Emissions/1000,2)

png(filename='./plot4.png')
plot(pm_cc$year,pm_cc$Emissions,type="l",xlab= "Year",col="red",main=expression("Total Emission of PM"[2.5]),ylab= expression(paste("PM",''[2.5]," in kilotons")))
text(pm_cc$year,pm_cc$Emissions,labels = pm_cc$Emissions,adj = c(0,1))

dev.off()