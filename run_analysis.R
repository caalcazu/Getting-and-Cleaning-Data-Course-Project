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
Xtestset <- fread("./data/test/X_test.txt")
Ytestlabels <- fread("./data/test/Y_test.txt")
Subject_test <- fread("./data/test/subject_test.txt")

Xtrainset <- fread("./data/train/X_train.txt")
Ytrainlabels <- fread("./data/train/Y_train.txt")
Subject_train <- fread("./data/train/subject_train.txt")

#Vizualizate the data read
View(fread("./data/test/X_test.txt"))
View(fread("./data/test/Y_test.txt"))
View(fread("./data/test/subject_test.txt"))
View(fread("./data/train/X_train.txt"))
View(fread("./data/train/Y_train.txt"))
View(fread("./data/train/subject_train.txt"))


# Merge Subject Data
SubjectData <- rbind(Subject_test, Subject_train)
names(SubjectData)<-c("subject")
View(SubjectData)

# Merge Activity Data
ActivityData <- rbind(Ytestlabels, Ytrainlabels)
names(ActivityData)<- c("activity")
View(ActivityData)

# Merge Data Set
XData <- rbind(Xtestset, Xtrainset)
features <- fread("./data/features.txt")
names(XData) <- as.character(features$V2)
View(XData)

#Merge Columns to FinalData
FinalData <- data.frame(SubjectData, ActivityData, XData)
View(FinalData)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#Estracts the name of the measures
mean_std_measures<-features$V2[grep("mean|std", features$V2)]
#Estracts the numbers of the columns of the variables.
names <- names(FinalData)
mean_std.measures <- grep("mean|std", names)

#Uses descriptive activity names to name the activities in the data set
activity_names <- fread("./data/activity_labels.txt")
setnames(activity_names, names(activity_names), c("activity", "activityName"))
FinalData <- data.frame(SubjectData, ActivityData, XData)
FinalData1 <- merge(activity_names, FinalData,   by ="activity")
View(FinalData1)


# 4. Appropriately labels the data set with descriptive variable names.

names(FinalData1)<-gsub("^t", "time", names(FinalData1))
names(FinalData1)<-gsub("Acc", "Accelerometer", names(FinalData1))
names(FinalData1)<-gsub("Gyro", "Gyroscope", names(FinalData1))
names(FinalData1)<-gsub("Mag", "Magnitude", names(FinalData1))
names(FinalData1)<-gsub("^f", "frequency", names(FinalData1))
names(FinalData1)

# 5 From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

library(plyr);
FinalData2<-aggregate(. ~subject + activityName, FinalData1, mean)
FinalData2<-FinalData2[order(FinalData2$subject,FinalData2$activityName),]
write.table(FinalData2, file = "tidydata.txt",row.name=FALSE)
