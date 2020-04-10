setwd("C:\\Rfiles\\GettingAndCleaningData")
library(dplyr)

filename <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# 1. Merges the training and the test sets to create one data set.
x<-rbind(x_test,x_train)
y<-rbind(y_test,y_train)
sub<-rbind(subject_test,subject_train)
merged<-cbind(x,y,sub)


# 2. Extracts only the measurements on the mean and 
#    standard deviation for each measurement.
tidyset<-merged %>% select(subject, code, contains("mean"), contains("std"))


# 3. Uses descriptive activity names to name the activities in the data set
tidyset$code<-activities[merged$code,2]

# 4. Appropriately labels the data set with descriptive variable names.
names(tidyset)[2] = "activity"
names(tidyset)<-gsub("Acc", "Accelerometer", names(tidyset))
names(tidyset)<-gsub("Gyro", "Gyroscope", names(tidyset))
names(tidyset)<-gsub("BodyBody", "Body", names(tidyset))
names(tidyset)<-gsub("Mag", "Magnitude", names(tidyset))
names(tidyset)<-gsub("^t", "Time", names(tidyset))
names(tidyset)<-gsub("^f", "Frequency", names(tidyset))
names(tidyset)<-gsub("tBody", "TimeBody", names(tidyset))
names(tidyset)<-gsub("-mean()", "Mean", names(tidyset), ignore.case = TRUE)
names(tidyset)<-gsub("-std()", "STD", names(tidyset), ignore.case = TRUE)
names(tidyset)<-gsub("-freq()", "Frequency", names(tidyset), ignore.case = TRUE)
names(tidyset)<-gsub("angle", "Angle", names(tidyset))
names(tidyset)<-gsub("gravity", "Gravity", names(tidyset))

# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

FinalData <- tidyset %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))


write.table(FinalData, "FinalData.txt", row.name=FALSE)

