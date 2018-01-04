
# Declaring variables 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"
dataPath <- "UCI HAR Dataset"



# 1. Downloading and unzipping the dataset : 
if (!file.exists(zipFile)) {
  download.file(url, zipFile, mode = "w")
}

# 2. unziping zip file if the zip file is there

if (!file.exists(dataPath)) {
  unzip(zipFile)
}

# Reading Activity files
dataActivityTest  <- read.table(file.path(dataPath, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(dataPath, "train", "Y_train.txt"),header = FALSE)

# Read Subject files
dataSubjectTrain <- read.table(file.path(dataPath, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(dataPath, "test" , "subject_test.txt"),header = FALSE)

# Reading Features files
dataFeaturesTest  <- read.table(file.path(dataPath, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(dataPath, "train", "X_train.txt"),header = FALSE)


# 1.Concatenate the data tables by rows

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

# 2.set names to variables

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(dataPath, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

# 3.Merge columns to get the data frame Data for all data

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

# 1.Read descriptive activity names from “activity_labels.txt”
activityLabels <- read.table(file.path(dataPath, "activity_labels.txt"),header = FALSE)
head(Data$activity,30)

# DatA labelling

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

