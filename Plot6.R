## IMPORTANT: YOU NEED TO HAVE THE SOURCE DATA AND PLOT6.R FILES IN THE SAME DIRECTORY
## TO GET THE RESULTS NEEDED.
## 6.Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle 
## sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes 
## over time in motor vehicle emissions?

library(ggplot2)

## Read the required .RDS files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
# Get Baltimore & LA information 
Baltimore<-subset(NEI,fips == "24510")
LA<-subset(NEI,fips == "06037")
Cities<- rbind(Baltimore,LA)
#Get the data of Vehicle emission
vehicle<-grep("vehicle",tolower(SCC$EI.Sector))   # Get the row number where the name vehicle is found 
vehicle<-as.character(SCC[vehicle,1])             # Get the SCC numbers for the identified rows
DataCities<-data.frame()                          
# Extract observations that have a SCC number related to vehicles
for (i in 1:length(vehicle)) {
        temp<-Cities[Cities$SCC==vehicle[i],]
        DataCities<-rbind(DataCities,temp)
}
# Summarise total emissions by year & each type
types<-split(DataCities,DataCities$fips)
SumTypes<-data.frame()
for (i in 1:length(types)) {
        each<-tapply(types[[i]]$Emissions,types[[i]]$year,sum)
        each<-cbind(rep(names(types)[i],length(each)),names(each),unname(each))
        SumTypes<-rbind(SumTypes,each)
}
#Adapt the final frame
names(SumTypes)<-names(DataCities[c(1,6,4)])
SumTypes$fips<-gsub("24510","Baltimore City",SumTypes$fips,)
SumTypes$fips<-gsub("06037","Los Angeles County",SumTypes$fips,)
SumTypes$fips<-as.factor(SumTypes$fips)
#Open the device & Plot the graphic
png("Plot6.png")
plot<-ggplot(SumTypes,aes(SumTypes$year,as.numeric(as.character(SumTypes$Emissions)),group=SumTypes$fips))
plot<-plot+geom_line(aes(color=SumTypes$fips))+theme_bw()+geom_point(aes(color=SumTypes$fips))
plot<-plot+labs(x="Year",
                y="Total PM2.5 emissions (by ton)",
                title="Total vehicle PM2.5 Emissions of Baltimore Vs. Los Angeles",
                legend="Type of PM2.5 source") + scale_colour_discrete(name="Region")

print(plot)
dev.off()
