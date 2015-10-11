## Project 1, Exploratory Data Analysis
## Series of scripts to print out plots (plot1.r - plot4.r)
## 10/11/2015

# CLEAN HOUSE
rm(list = ls())
for(i in 1:5) gc()

options(stringsAsFactors=FALSE)

######## DATA PREP ########

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("./data")){dir.create("./data")}
zipfn <- "./data/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url = fileURL,destfile = zipfn)


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

png("plot1.png", width = 480, height = 480)
hist(data$Global_active_power,col='red',xlab="Global Active Power (kilowatts)",main="Global Active Power")
dev.off()

png("plot2.png", width = 480, height = 480)
plot(data$datetime,data$Global_active_power,ylab="Global Active Power (kilowatts)",type = 'l',xlab="datetime")
dev.off()

png("plot3.png", width = 480, height = 480)
plot(data$datetime,data$Sub_metering_1,ylab="Energy sub metering",type = 'l',xlab="")
lines(data$datetime,data$Sub_metering_2,col="red")
lines(data$datetime,data$Sub_metering_3,col="blue")
legend("topright",
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lwd=c(2.5,2.5,2.5),
       col=c("black","blue","red"))

dev.off()


png(file='plot4.png')
par(mfrow= c(2, 2))
plot(data$datetime,data$Global_active_power,ylab="Global Active Power",type = 'l',xlab="")
plot(data$datetime,data$Voltage,ylab="Voltage",type = 'l',xlab="datetime")
plot(data$datetime,data$Sub_metering_1,ylab="Energy sub metering",type = 'l',xlab="")
lines(data$datetime,data$Sub_metering_2,col="red")
lines(data$datetime,data$Sub_metering_3,col="blue")
legend("topright",
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lwd=c(2.5,2.5,2.5),
       col=c("black","blue","red"),
       bty="n")
plot(data$datetime,data$Global_reactive_power,ylab="Global_reactive_power",type = 'l',xlab="datetime")
dev.off()

