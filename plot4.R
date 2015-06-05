plot4 <- function() {
        #plot3() download the data from internet, and plot 4 graphs: 
        #       the evolution of Global active power
        #       the evolution of Voltage
        #       the evolution of the 3 Sub metering
        #       the evolution of the Global reactive power
        # during 01/02/2007 and 02/02/2007
        
        # donwload of the file if it hasn't already been done
        urldata <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        if (!file.exists("data.zip")) {
                download.file(urldata,destfile="data.zip")
        }
        
        # reading the file if it hasn't been already done
        if (!file.exists("data.csv")) {
                con <- unz("data.zip","household_power_consumption.txt")
                #In order to read only the 01 an 02 February data we have to 
                # skip the first 66637 rows and read only 
                # the 24(h)*60(min)*2days following rows
                data <- read.table(con,sep=";",skip=66637,nrow=24*60*2,na.strings="?")
                write.csv(data,file="data.csv")
        } else {
                data <- read.csv("data.csv")
        }
        
        #My pc is setup in French so I have to set the local time language
        # to English to avoid confusion in day and month names
        Sys.setlocale("LC_TIME","English")
        
        # setting the headers and formating Date and Time
        names(data) <- c("Num","Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")
        data$Time <- paste(data$Date,data$Time)
        data$Time <- strptime(data$Time,"%d/%m/%Y %H:%M:%S")
        data$Date <- as.Date(data$Date,format="%d/%m/%Y")

        # creating the plot in the PNG graphic device plot4.png  
        png(file = "plot4.png",width=480,height=480)
        par(mfrow = c(2,2)) #, mar=c(4,4,2,1), oma=c(0,0,2,0)) 
        
        with(data,plot(Time,Global_active_power,type="l",xlab = "",ylab="Global Active Power"))
        
        with(data,plot(Time,Voltage,type="l",xlab = "datetime",ylab="Voltage"))
        
        with(data,plot(Time,Sub_metering_1,type="l",xlab = "",ylab="Energy sub metering"))
        with(data,points(Time,Sub_metering_2,type="l",xlab = "",col="red"))
        with(data,points(Time,Sub_metering_3,type="l",xlab = "",col="blue"))
        legend("topright",lty=1,bty="n",col=c("black","blue","red"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
        
        with(data,plot(Time,Global_reactive_power,type="l",xlab="datetime"))
        
        dev.off()
        Sys.setlocale("LC_TIME","French") #back to French
}