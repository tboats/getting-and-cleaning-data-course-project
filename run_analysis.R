setwd("E:/Dropbox/R/Data Science Specialization/getting and cleaning data/course project")

# Step 1: Merges the training and the test sets to create one data set.

# look for files in training directory
dataDirs<-c("train","test")

# initialize data frame
dfs<-data.frame() # final data frame

# read the features in (to be column names)
features<-read.table("features.txt")
colNames<-features[,2]

for (dataDir in dataDirs){
    files<-list.files(dataDir,pattern=".txt")
    df<-data.frame() # combined within each folder
    for (file in files){
        # construct the file path
        filePath<-paste(dataDir,file,sep="/")
        varName<-substr(file, 1, nchar(file)-4)
        varName<-strsplit(varName,"_")[[1]][1] # omit test/train
        
        # read data
        dat<-read.table(filePath) 
        
        # save to data frame
        if (dim(dat)[2]<=1){
            names(dat)<-varName
            if (dim(df)[1]==0){df<-dat} else {
                df<-cbind(df,dat) # combine test/train set
            }
        } else{
            names(dat)<-colNames # assign the "features" column names
            df<-cbind(df,dat) # combine test/train set
        }   
    }
    df$dataset<-dataDir # keep track of whether from test or training
    dfs<-rbind(dfs,df) # combine the data frames
}


# Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
stdCols<-grepl("std",names(dfs),ignore.case=T) # which columns have "std" in name
meanCols<-grepl("mean",names(dfs),ignore.case=T) # which columns have "mean" in name
idCols<-names(dfs) %in% c("y","subject","dataset") # which are ID/outcome columns
colsOI<-stdCols | meanCols | idCols

dfs2<-dfs[,colsOI]

# Step 3: Uses descriptive activity names to name the activities in the data set
# read the labels for the activities (in the "y_train" variable)
activityList<-read.table("activity_labels.txt")

# use factors to pass the labels into the "activity" column for df3
dfs3<-dfs2
dfs3$activity<-dfs3$y
dfs3$activity<-factor(dfs3$activity,labels=activityList[,2])

# Step 4: Appropriately labels the data set with descriptive variable names. 
# This was done in step 1

# Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
# first melt the data frame down, keeping the subject and activity as IDs
dm<-melt(dfs3, id.vars=c("y","subject","activity","dataset"))
# use dcast from reshape2 to aggregate the melted data frame
dfs5<-dcast(dm,subject + activity + dataset ~ variable, fun.aggregate=mean)
dfs5$subject<-as.factor(dfs5$subject)

# write to disk
write.table(dfs5,"tidy-data_train-test.txt",row.names=FALSE)