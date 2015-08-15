---
title: "CodeBook for Getting and Cleaning Data Project"
author: "tboats"
date: "Friday, August 14, 2015"
---


data location: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Processing of the data:
==================================================================
Step 1: 
==================================================================

All the files within the zip file were extracted into the base directory for this project.  The first task in the assignment is to merge the test and training data.  This was done through iterating over the train and test folders and loading in all the txt files.  If the txt file had just a single column, the name of that file was given to that column of data.  If not, the features listed in "features.txt" was given as the name (to the X_*.txt file).  Once the data in each folder were loaded, they were combined via "rbind" in R.  The data set the sets belonged to is stored in the "dataset" variable.

Step 2: 
==================================================================

The task was given to extract the measurements that contain means or standard deviations.  The column names (561 of them) were searched for the strings "mean" and "std".  Any feature which contained a case-insensitive match to these strings was kept as a variable.  In addition, identification attributes were kept (activity/y, subject, dataset).  The data were then stored in variable "dfs2".

Step 3:
==================================================================

The task was to assign a descriptive text name for each "y".  This was extracted from the "activity_labels.txt" file in the original data set.  They were applied to the "y" column through coercing it to be a factor with the labels in the file.

Step 4:
==================================================================

The feature names were loaded in the initial data load in step 1.

Step 5:
==================================================================

The task was to summarize the data set by taking the average of each attribute for each subject and each activity.  This was accomplished through the "reshape2" package functions "melt" and "dcast".  First, "melt" was used to convert the data set to long form, with the ID columns plus variable and value.  Then the "dcast" function was used to convert to wide form, with the mean function used to average across subject and activity.  This was stored in variable "dfs5".  Finally, a text output was generated named "tidy-data_train-test.txt".

Added attributes:
==================================================================
dataset: contains whether from the test or train set
activity: text describing the subject activity from the "activity_labels.txt" file

Important variables:
==================================================================
 -dfs: original merged test/train data set
 
 -dfs2: dfs with non-mean and non-std columns removed
 
 -dfs3: dfs2 with activity attribute added
 
 -dfs5: dfs3 reshaped to have mean of each column for each subject and activity
 
 -dm: melted dfs3 data set

For information on all other attributes, look at the "features.txt" or "features_info.txt" files. The "tidy-data_train-test.txt" file contains the average of those variables for each subject and activity.