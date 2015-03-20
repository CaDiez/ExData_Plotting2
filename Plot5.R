## IMPORTANT: YOU NEED TO HAVE THE SOURCE DATA AND PLOT5.R FILES IN THE SAME DIRECTORY
## TO GET THE RESULTS NEEDED.
## 5.How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City? 

## Read the required .RDS files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#Get Baltimore Data
Baltimore <- NEI[which(NEI$fips == "24510"),]
#Get the data of Vehicle emission
vehicle<-grep("vehicle",tolower(SCC$EI.Sector))   # Get the row number where the name vehicle is found 
vehicle<-as.character(SCC[vehicle,1])             # Get the SCC numbers for the identified rows 
data<-data.frame()                              
# Extract observations that have a SCC number related to vehicles
for (i in 1:length(vehicle)) { 
        temp<-Baltimore[Baltimore$SCC==vehicle[i],] 
        data<-rbind(data,temp) 
        } 
# Summarise by Year
total<-tapply(Baltimore$Emissions,Baltimore$year,sum) 
#Get Plot Information
year<-names(total) 
emissions<-unname(total) 
#Open the device & Plot the graphic
png("Plot5.png")
plot(emissions~year, 
     xlab="Year",
     ylab="Total PM2.5 emissions (by tons)", 
     col="red", 
     xlim=c(1998,2009), 
     pch=19,
     main = "Total PM2.5 Emissions in Baltimore from Motor Vehicles") 
points(emissions~year,col="blue",type="l") 
dev.off()