## IMPORTANT: YOU NEED TO HAVE THE SOURCE DATA AND PLOT3.R FILES IN THE SAME DIRECTORY
## TO GET THE RESULTS NEEDED.
## 3.- Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
## which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? 
## Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot
## answer this question

library(ggplot2)

## We will read only the dataset which is needed for this task
NEI <- readRDS("summarySCC_PM25.rds")
#Get only Baltimore information
Baltimore<-subset(NEI,fips == "24510")
# Split the Baltimore data and get total emission por year for each type
Sources<-split(Baltimore,Baltimore$type)
SumSources<-data.frame()
for (i in 1:length(Sources)) 
        {
        SumByType<-tapply(Sources[[i]]$Emissions,Sources[[i]]$year,sum)
        SumByType<-cbind(rep(names(Sources)[i],length(SumByType)),names(SumByType),unname(SumByType))
        SumSources<-rbind(SumSources,SumByType)
        }
names(SumSources)<-names(Baltimore[c(5,6,4)])
#Open a PNG device and plot
png("Plot3.png")
plot<-ggplot(SumSources,aes(SumSources$year,as.numeric(as.character(SumSources$Emissions)), group=SumSources$type))
plot<- plot + geom_line(aes(color=SumSources$type))+theme_bw()+geom_point(aes(color=SumSources$type))
plot <- plot +labs(x="Year",
                y="Total PM2.5 emissions (by Tons.)", 
                title="Total PM2.5 emissions of Baltimore by Source Type",
                legend="Type of PM2.5 source") + scale_colour_discrete(name="Type of PM2.5 source")
#Print & close device
print(plot)
dev.off()

