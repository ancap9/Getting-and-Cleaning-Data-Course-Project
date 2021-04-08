

library(dplyr)


##############################################################################

# download zip file with data

zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"

if (!file.exists(zipFile)) {
    download.file(zipUrl, zipFile, method="curl")
}

# unzip zip file containing data if data directory doesn't already exist
dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
    unzip(zipFile)
}


##############################################################################

# loading/reading train and test data

trainingSubjects <- read.table(file.path(dataPath, "train", "subject_train.txt"))
trainingValues <- read.table(file.path(dataPath, "train", "X_train.txt"))
trainingActivity <- read.table(file.path(dataPath, "train", "y_train.txt"))

testSubjects <- read.table(file.path(dataPath, "test", "subject_test.txt"))
testValues <- read.table(file.path(dataPath, "test", "X_test.txt"))
testActivity <- read.table(file.path(dataPath, "test", "y_test.txt"))

# read features, 
features <- read.table(file.path(dataPath, "features.txt"), as.is = TRUE)

# read activity labels
activities <- read.table(file.path(dataPath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")

##############################################################################

# Merge the training and the test sets
allData <- rbind(
    cbind(trainingSubjects, trainingValues, trainingActivity),
    cbind(testSubjects, testValues, testActivity)
)


# assign column names
colnames(allData) <- c("subject", features[, 2], "activity")

##############################################################################

# Extract only the measurements on the mean and standard deviation

columnsOK <- grepl("subject|activity|mean|std", colnames(allData))

allData <- allData[, columnsOK]


##############################################################################

# Descriptive activity names

allData$activity <- factor(allData$activity, 
                                 levels = activities[, 1], labels = activities[, 2])


##############################################################################


# final tidy data set with the average


allDataMeans <- allData %>% 
    group_by(subject, activity) %>%
    summarise_each(funs(mean))

# output to file "tidy_data.txt"
write.table(allDataMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)





















