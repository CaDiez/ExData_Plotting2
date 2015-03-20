## IMPORTANT: YOU NEED TO HAVE THE SOURCE DATA AND PLOT4.R FILES IN THE SAME DIRECTORY
## TO GET THE RESULTS NEEDED.
## 4.- Across the United States, how have emissions from coal combustion-related sources changed from 
## 1999-2008?

library(plyr)

# Get the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
# convert scc levels to lower case so that I have not matching issues on case 
SCC.L1 <- tolower(SCC$SCC.Level.One) 
SCC.L3 <- tolower(SCC$SCC.Level.Three) 
#Get Only Combustion By Coal Sources
coalCombustion <- SCC[grepl("combustion", SCC.L1)&grepl("coal", SCC.L3),]
## Merge the filtered file with NEI and summarise by year
MergedFrame <- merge(NEI, coalCombustion)
MergedFrame <- ddply(.data=data.frame(MergedFrame$Emissions),
            .variables=.(MergedFrame$year), colwise(sum))
names(MergedFrame) <- c("year", "emissions")
#Add readability to the graphic
TotEmissions<-MergedFrame$emissions/100000
#Open the device & Plot the graphic
png("Plot4.png")
plot(TotEmissions~MergedFrame$year, 
xlab="Year",
ylab="Total PM2.5 emissions (divided by 100000 tons)", 
col="red", 
xlim=c(1998,2009), 
pch=19,
main = "Total PM2.5 emissions in the US from coal combustion") 
points(TotEmissions~MergedFrame$year,col="blue",type="l") 
#Close the device
dev.off()