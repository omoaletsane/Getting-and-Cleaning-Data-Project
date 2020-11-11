### Prepare LIBs
library("dplyr")
install.packages("reshape2")
library("reshape2")

### Checking and creating the Directory
if (!file.exists(rawDataDir)) {
    dir.create(rawDataDir)
}
if (!file.exists(rawDataDir)) {
    dir.create(rawDataDir)
}
### Get dataset from web
rawDataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(rawDataUrl, destfile = "./rawDataDir/rawDataDFn")
unzip(zipfile = rawDataDFn, exdir = dataDir)
rawDataFilename <- "rawData.zip"
rawDataDFn <- paste(rawDataDir, "/", "rawData.zip", sep = "")
dataDir <- "./data"

### Merge {train, test} data set
### Refer: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
### Train data
x_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/Y_train.txt"))
s_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/subject_train.txt"))

### Test data
x_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/Y_test.txt"))
s_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/subject_test.txt"))

### Merge {train, test} data
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)


#### Load feature & activity info
### Feature info
feature <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/features.txt"))

### Activity labels
a_label <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/activity_labels.txt"))
a_label[,2] <- as.character(a_label[,2])

### Extract feature column & names named 'mean, std'
selectedCols <- grep("-(mean|std).*", as.character(feature[,2]))
selectedColNames <- feature[selectedCols, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)


### Extract data by column & using descriptive name
x_data <- x_data[selectedCols]
allData <- cbind(s_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

allData$Activity <- factor(allData$Activity, levels = a_label[,1], labels = a_label[,2])
allData$Subject <- as.factor(allData$Subject)

### Generate tidy data set
meltedData <- melt(allData, id = c("Subject", "Activity"))
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)

write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)
