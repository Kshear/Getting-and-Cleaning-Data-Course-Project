#Load libraries

library(data.table)
library(dplyr)

#Reading Metadata
featureNames <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

#Formatting data sets

subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

#Combine training and testing datasets

subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

#Naming the columns

colnames(features) <- t(featureNames[2])

#Merge the data

colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)

#Extracts columns that have mean or Std in them
columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=T)

requiredColumns <- c(columnsWithMeanSTD, 562, 563)
dim(completeData)

extractedData <-completeData[,requiredColumns]
dim(extractedData)

##3- Add desctiptive activity names to name activities in dataset

extractedData$Activity <- as.character(extractedData$Activity)
for(i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}

#factoring the activity variable
extractedData$Activity <- as.factor(extractedData$Activity)

##4.Apply appropraite labels with descriptive variable names

names(extractedData) #View names to see what can be improved

#Substitutes acronyms with clearer labels

names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^t", "Time", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))

names(extractedData) #double check new names

#5. Using data from step 4 create a second dataset 
#with the avg of each variable for each activity and each subject

#set "Subject" as factor variable

View(tidyData)

