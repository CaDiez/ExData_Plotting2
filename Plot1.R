## IMPORTANT: YOU NEED TO HAVE THE SOURCE DATA AND PLOT1.R FILES IN THE SAME DIRECTORY
## TO GET THE RESULTS NEEDED.
## 1.- Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?Using the base plotting system, make
##  a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

## We will read only the dataset which is needed for this task
NEI <- readRDS("summarySCC_PM25.rds")
# Summarise emmissions by year
TotEmission<-tapply(NEI$Emissions,NEI$year,sum)
#Get the plot information
Year<-names(TotEmission)
TotEmissions<-unname(TotEmission)
#Add readability to the graphic
TotEmissions<-TotEmissions/100000
#Open a PNG device and plot
png("Plot1.png")
plot(TotEmissions~Year,
     ylab="Total PM2.5 emissions (divided by 100000 tons)",
     col="black",
     xlim=c(1998,2008),
     main = "Total PM2.5 emissions in the US from 1999 to 2008",
     pch=19)
points(TotEmissions~Year,col="blue",type="l")
#Close the device
dev.off()
