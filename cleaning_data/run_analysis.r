##  Gathering and Cleaning Data final project
##  Create one R script called run_analysis.R that does the following:

## 1) Merges the training and the test sets to create one data set.
## 2) Extracts only the measurements on the mean and standard deviation 
##    for each measurement.
## 3) Uses descriptive activity names to name the activities in the data set
## 4) Appropriately labels the data set with descriptive variable names.
## 5) From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.
library(tidyr)
library(dplyr)

## Since the data has been randomly split between the train and and test
## sets using a 70/30 split between the two datasets, train and test are 
## not a variable:

##Bind the activity code and label to the train data set
trainfull <- cbind(y_train, X_train, stringsAsFactors = FALSE)

##Bind the subject code to the train data set
trainfull <- cbind(subject_train, trainfull, stringsAsFactors = FALSE)

##Properly name the train subject column
names(trainfull)[1] <- "Subject"

## Repeat the steps in train on the test dataset
testfull <- cbind(y_test, X_test, stringsAsFactors = FALSE)                  
testfull <- cbind(subject_test, testfull, stringsAsFactors = FALSE) 
names(testfull)[1] <- "Subject"

##Combine the two datasets by stacking them on top of each other using
## rbind, order that the datasets are bound does not matter:

fulldata <- rbind(trainfull, testfull, stringsAsFactors = FALSE)

## Apply the labels to the fulldata from the features dataframe accounting
## for the subject data previously rbinded to the beginning of fulldata.

h <- length(features[,2])
## offset to account for the subject and actvity code columns
## cbind'ed onto fulldata
 
for (i in 3:h){
  names(fulldata)[i] <- features[i,2]
}

## Convert the Activity_ID codes to corresponding Activity_Label 
## as directed in assignment using characters not factors. 
## Rename column when done

w <- length(fulldata[,1])
for (i in 1:w){
  
  if(fulldata[i,2] == 1){fulldata[i,2] <- as.character("WALKING")}
  if(fulldata[i,2] == 2){fulldata[i,2] <- as.character("WALKING_UPSTAIRS")}
  if(fulldata[i,2] == 3){fulldata[i,2] <- as.character("WALKING_DOWNSTAIRS")}
  if(fulldata[i,2] == 4){fulldata[i,2] <- as.character("SITTING")}
  if(fulldata[i,2] == 5){fulldata[i,2] <- as.character("STANDING")}
  if(fulldata[i,2] == 6){fulldata[i,2] <- as.character("LAYING")}
}
## Rename Activity column

names(fulldata)[2] <- as.character("Activity_Label")

## Remove any duplicate column names
fdata2 <- fulldata[ , !duplicated(colnames(fulldata))]

##  Extracts only the measurements on the mean and standard deviation 
##  for each measurement.

cn <- grep("mean()|std()", colnames(fulldata), value=T, ignore.case = TRUE)
fdata3 <- select(fdata2, 1:2, one_of(cn))

## 5) From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

## Summarise the columns and create new dataset
tidy_data <- fdata3 %>%
  group_by(Subject, Activity_Label) %>% 
  summarise_each(funs(mean), one_of(cn)) 

## Rename the columns to something meaningful
 f <- length(names(tidy_data))
 for (i in 3:f){
   k <- names(tidy_data)[i]
   l <- paste("Average of ", k)
   names(tidy_data)[i] <- l
 }
 


  
