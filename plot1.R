library(dplyr)
library(stringr) # str_c()
library(lubridate) # dmy_hms()

# Output the day of the week in English
Sys.setlocale(category = "LC_TIME", locale = "C")

rawDataFileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
workingDataPath <- file.path(".", "data")
downloadedZipfilePath <- file.path(workingDataPath, "downloaded_dataset.zip")
rawDataPath <- file.path(workingDataPath, "household_power_consumption.txt")
# Create working directory
if(!file.exists(workingDataPath)) {
        dir.create(workingDataPath)
}
# Download ziped file
if(!file.exists(downloadedZipfilePath)) {
        download.file(rawDataFileUrl, destfile = downloadedZipfilePath)
}
# Unzip
if(!file.exists(rawDataPath)) {
        unzip(zipfile = downloadedZipfilePath, exdir = workingDataPath)
}
# Read Data
dataset <- read.table(rawDataPath, header = TRUE, sep = ";", na.strings = "?",
                      colClasses = c("character", "character", rep("numeric", 7))) %>%
        # Using data from the dates 2007-02-01 and 2007-02-02
        filter(Date == "1/2/2007" | Date == "2/2/2007") %>%
        # Joining day and time to create a new date/time
        mutate(DateTimeText = str_c(Date, Time, sep = " "), 
               Time = dmy_hms(DateTimeText)) %>%
        select(-DateTimeText, -Date) %>%
        rename(DateTime = Time)

# Device ready
png("plot1.png", width = 480, height = 480)

# Plot
hist(dataset$Global_active_power, col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     ylab = "Frequency")

# Device off
dev.off()
