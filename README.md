# Getting and cleanind data course project
**This Readme explains each part of the run_analysis.R code and how to run it**

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 

1. a tidy data set as described below
1. a link to a Github repository with your script for performing the analysis
1. a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
1. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]()

Here are the data for the project:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]()

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Step 0 : Declaring variables 
	
	url <- "https://d396qusza40orc.cloudfront.net/	getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	zipFile <- "UCI HAR Dataset.zip"
	dataPath <- "UCI HAR Dataset"

## Step 1 : Getting and Unziping the data 


### 1. Downloading and unzipping the dataset : 
	if (!file.exists(zipFile)) {
  	download.file(url, zipFile, mode = "w")
	}

### 2. unziping zip file if the zip file is there

	if (!file.exists(dataPath)) {
 	 unzip(zipFile)
	}

### 3. We are going to list all the files we downloading
Using the terminal
	
	files
	 [1] "activity_labels.txt"                          "features_info.txt"
	 [3] "features.txt"                                 "README.txt"
	 [5] "test/Inertial Signals/body_acc_x_test.txt"    "test/Inertial Signals/body_acc_y_test.txt"   
	 [7] "test/Inertial Signals/body_acc_z_test.txt"    "test/Inertial Signals/body_gyro_x_test.txt"  
	 [9] "test/Inertial Signals/body_gyro_y_test.txt"   "test/Inertial Signals/body_gyro_z_test.txt"  
	[11] "test/Inertial Signals/total_acc_x_test.txt"   "test/Inertial Signals/total_acc_y_test.txt"  
	[13] "test/Inertial Signals/total_acc_z_test.txt"   "test/subject_test.txt"                       
	[15] "test/X_test.txt"                              "test/y_test.txt"                             
	[17] "train/Inertial Signals/body_acc_x_train.txt"  "train/Inertial Signals/body_acc_y_train.txt" 
	[19] "train/Inertial Signals/body_acc_z_train.txt"  "train/Inertial Signals/body_gyro_x_train.txt"
	[21] "train/Inertial Signals/body_gyro_y_train.txt" "train/Inertial Signals/body_gyro_z_train.txt"
	[23] "train/Inertial Signals/total_acc_x_train.txt" "train/Inertial Signals/total_acc_y_train.txt"
	[25] "train/Inertial Signals/total_acc_z_train.txt" "train/subject_train.txt"                     
	[27] "train/X_train.txt"                            "train/y_train.txt" 
 
	
## Step 2 : Reading the files 

### Reading Activity files
	dataActivityTest  <- read.table(file.path(dataPath, "test" , 	"Y_test.txt" ),header = FALSE)
	dataActivityTrain <- read.table(file.path(dataPath, "train", 	"Y_train.txt"),header = FALSE)

### Read Subject files
	dataSubjectTrain <- read.table(file.path(dataPath, "train", 	"subject_train.txt"),header = FALSE)
	dataSubjectTest  <- read.table(file.path(dataPath, "test" , 	"subject_test.txt"),header = FALSE)

### Reading Features files
	dataFeaturesTest  <- read.table(file.path(dataPath, "test" , 	"X_test.txt" ),header = FALSE)
	dataFeaturesTrain <- read.table(file.path(dataPath, "train", "X_train.txt"),header = FALSE)

# Step 3 : Concatenation and merge of all the data

### 1.Concatenate the data tables by rows

	dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
	dataActivity<- rbind(dataActivityTrain, dataActivityTest)
	dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

### 2.set names to variables

	names(dataSubject)<-c("subject")
	names(dataActivity)<- c("activity")
	dataFeaturesNames <- read.table(file.path(dataPath, "features.txt"),head=FALSE)
	names(dataFeatures)<- dataFeaturesNames$V2

#### 3.Merging columns for getting all the data
	dataCombine <- cbind(dataSubject, dataActivity)
	Data <- cbind(dataFeatures, dataCombine)

### Reading activity names from “activity_labels.txt”
	activityLabels <- read.table(file.path(dataPath, "activity_labels.txt"),header = FALSE)
	head(Data$activity,30)

# Step 4 : Data labelling

	names(Data)<-gsub("^t", "time", names(Data))
	names(Data)<-gsub("^f", "frequency", names(Data))
	names(Data)<-gsub("Acc", "Accelerometer", names(Data))
	names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
	names(Data)<-gsub("Mag", "Magnitude", names(Data))
	names(Data)<-gsub("BodyBody", "Body", names(Data))

	Data2<-aggregate(. ~subject + activity, Data, mean)
	Data2<-Data2[order(Data2$subject,Data2$activity),]
	write.table(Data2, file = "tidydata.txt",row.name=FALSE)

