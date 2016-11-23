Gathering and Cleaning Data final project
Create one R script called run_analysis.R that does the following:

 1) Merges the training and the test sets to create one data set.
 2) Extracts only the measurements on the mean and standard deviation 
    for each measurement.
 3) Uses descriptive activity names to name the activities in the data set
 4) Appropriately labels the data set with descriptive variable names.
 5) From the data set in step 4, creates a second, independent tidy data set 
    with the average of each variable for each activity and each subject.

1) 
	Since the data has been randomly split between the train and and test
sets using a 70/30 split between the two datasets, train and test are 
not a variable.

meanFreq was included since it is a mean of the Frequency and met the assignment criteria. 

cbind the activity code and label to the train data set
cbind the subject code to the train data set
Properly name the train subject column
Repeat the steps in train on the test dataset
Combine the two datasets by stacking them on top of each other using
rbind, order that the datasets are bound does not matter:

Apply the labels to the fulldata from the features dataframe accounting for 
the subject data previously rbinded to the beginning of fulldata.

2) Remove any duplicate column names
  Extract only the measurements on the mean and standard deviation 
  for each measurement using grep being sure to capture mean(), std() independent of case.

3)  Convert the Activity_ID codes to corresponding Activity_Label 
 as directed in assignment using characters not factors, used a for loop. 
 Rename column when done.

4) Applied the appropriate column names to the Subject codes and Activity_Label 
during cbind.

5)  Used dplyr to pipe the resulting dataset through a group_by, summarise_each(funs(mean) 
then renamed the columns to reflect the activity, Average of pasted onto the previous column name.   
