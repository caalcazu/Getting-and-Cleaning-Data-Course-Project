# Download data set Assignment: Getting and Cleaning Data Course Project

if (!file.exists("data")){
        dir.create("data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(fileUrl, destfile ="./data/Dataset.zip")

list.files(".")

dateDownloaded <- date()

# Define the directory of the data set Assignment: Getting and Cleaning Data Course Project
pathdata <- file.path("./data")
list.files(pathdata, recursive = TRUE)

# Read the data ro the Assignment: Getting and Cleaning Data Course Project and assign all of them to a object
library(data.table)
library(dplyr)

features <- read.table("./data/features.txt")

activity_labels <- read.table("./data/activity_labels.txt")

X_test <- read.table("./data/test/X_test.txt")
Y_test <- read.table("./data/test/Y_test.txt")
subject_test <- read.table("./data/test/subject_test.txt")


X_train <- read.table("./data/train/X_train.txt")
Y_train <- read.table("./data/train/Y_train.txt")
subject_train <- read.table("./data/train/subject_train.txt")

#Merge Activity Data (Y), Subject Data (Subject) and DataX (X)
X <- rbind(X_test, X_train)
Y <- rbind(Y_test, Y_train)
subject <- rbind(subject_test, subject_train)

# Assign header to the three combined data sets
names(X) <- features[,2]
names(Y) <- "activityId"
names(subject) <- "subjectId"

#Obtain the Final Data set 
FinalData <- cbind(subject, Y, X)


# 2 Extracts the measurements on the mean and standard deviation for each measurement.
col_names <- names(FinalData)[grep("subject|activityId|mean|std",names(FinalData))]
FinalData1 <- FinalData[col_names]

## Step 3: Uses descriptive activity names to name the activities in the data set

names(activity_labels) <- c("activityId", "activityName")
FinalData2 <- merge(activity_labels, FinalData1,  by = "activityId")
FinalData2 <- select(FinalData2, -(activityId))
View(FinalData2)


# 4. Appropriately labels the data set with descriptive variable names.

names(FinalData2)<-gsub("^t", "time", names(FinalData2))
names(FinalData2)<-gsub("Acc", "Accelerometer", names(FinalData2))
names(FinalData2)<-gsub("Gyro", "Gyroscope", names(FinalData2))
names(FinalData2)<-gsub("Mag", "Magnitude", names(FinalData2))
names(FinalData2)<-gsub("^f", "frequency", names(FinalData2))
names(FinalData2)

# 5 From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
library(plyr)
FinalData3<-aggregate(. ~subjectId + activityName, FinalData2, mean)
FinalData3<-FinalData3[order(FinalData3$subjectId,FinalData3$activityName),]
write.table(FinalData3, file = "tidydata.txt",row.name=FALSE)
