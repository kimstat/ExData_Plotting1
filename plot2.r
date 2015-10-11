## Project 1, Exploratory Data Analysis
## Series of scripts to print out plots (plot1.r - plot4.r)
## 10/11/2015

# CLEAN HOUSE
rm(list = ls())
for(i in 1:5) gc()

# SET WORKING DIRECTORY
setwd("c:/School/Coursera/ExploratoryDataAnalysis/")

######## DATA PREP ########

# originally downloaded from URL
# fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# data_location <- "C:/School/Coursera/ExploratoryDataAnalysis/"
# download.file(url = fileURL,destfile = data_location)
# now just load from local
zipfn <- "C:/School/Coursera/ExploratoryDataAnalysis/exdata-data-household_power_consumption.zip"

# identify relavent files
options(stringsAsFactors=FALSE)
# look at which files are in Zip
files <- unzip(zipfile = zipfn,list=T)$Name
# bring in the 1st row which contains the column names
data_names <- colnames(read.table(unz(zipfn, files),nrows = 1,sep = ";",header =T) )
# read rest of table table (i played with the nrows and skip values so that i didn't load too much, but got the right dates)
data <- read.table(unz(zipfn, files),nrows = 10000,sep = ";",header =T,skip = 60000) 
# add your column names back
colnames(data) <- data_names
str(data)
# select only dates we're interested in
data$Date <- as.Date(data$Date,format="%d/%m/%Y")
head(data[which(data$Date<=as.Date("2007-02-02") & data$Date>=as.Date("2007-02-01")),])
data <- data[which(data$Date<=as.Date("2007-02-02") & data$Date>=as.Date("2007-02-01")),]
# all numbers were brought in as characters.. convert to numeric
data[,3:9] <- as.data.frame(apply(data[,3:9],MARGIN = 2,as.numeric))

# prof suggested using datetime format, so convertime here
data$datetime <- strptime(paste(data$Date,data$Time,sep=" "),format="%Y-%m-%d %H:%M:%S")


######## PLOT ########

png("plot2.png", width = 480, height = 480)
plot(data$datetime,data$Global_active_power,ylab="Global Active Power (kilowatts)",type = 'l',xlab="datetime")
dev.off()
