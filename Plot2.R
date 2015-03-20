## IMPORTANT: YOU NEED TO HAVE THE SOURCE DATA AND PLOT2.R FILES IN THE SAME DIRECTORY
## TO GET THE RESULTS NEEDED.
## 2.Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 
## 1999 to 2008? Use the base plotting system to make a plot answering this question.

## We will read only the dataset which is needed for this task
NEI <- readRDS("summarySCC_PM25.rds")
#Get only Baltimore information
Baltimore<-subset(NEI,fips == "24510")
# Summarise emmissions by year
TotEmission<-tapply(Baltimore$Emissions,Baltimore$year,sum)
#Get the plot information
Year<-names(TotEmission)
TotEmissions<-unname(TotEmission)
#Open a PNG device and plot
png("Plot2.png")
plot(TotEmissions~Year,
     ylab="Total PM2.5 emissions (by tons)",
     col="black",
     xlim=c(1998,2008),
     main = "Total PM2.5 emissions in Baltimore from 1999 to 2008",
     pch=19)
points(TotEmissions~Year,col="blue",type="l")
#Close the device
dev.off()
