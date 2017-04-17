## Getting and Cleaning Data Course Project
## This takes the raw data, combines test and train, tidies it, subsets only the mean and standard deviation values,
## and then computes the average of those values grouped by subject and activity type.
##
## Required packages: dplyr, data.table
##
## Pseudocode explanation of what is done
## 1. Read in the activities, updating column names to activityid and activityname
## 2. Read in the features, updating column names to featureid and featurename. Process featurename
##      column by removing "(" and ")", changing "-" and "," to "_", lowercasing feature names. 
## 3. Process test files by doing the following:
##      a. Reading in subject_test file, naming column as subjectid
##      b. Reading in X_test file, changing column names to the cleaned feature names.
##      c. Reading in Y_test file, changing column name to activityid.
##      d. Joining the Y_test data with the activities data to get an activity name.
##      e. Combining the subject and activity name for each row with the measurements for each activity
## 4. Repeating the steps in 3 for the training data.
## 5. Appending the rows of the training data to the test data.
## 6. Identifying which columns are mean or standard deviations (ignoring meanFreq or Mean labeled 
##      variables)
## 7. Create a new data set with just the columns referencing mean or standard deviation.
## 8. Taking the data set from 7, and grouping it by subject and activity.
## 9. Then getting the mean on each column for each subject/activity combination, outputing the data.

## produceCleanedData is the primary function called to output cleaned data files
## 
## argument: rootFileDir is the directory in which the "UCI HAR Dataset" folder exists
##
## ouptput:
##      subsetDataOutput.csv is a file with the tidy and subsetted data with mean and stdev
##      averageSubsetDataOutput.csv is a file that averages the values from the previous file 
##              by subject and activity type
produceCleanedData <- function(rootFileDir)
{
  if (!is.null(rootFileDir))
  {
    subsetData <- getTidyData(rootFileDir);
    averageSubsetData <- getAverageSubsetData(subsetData);
    
    write.table(subsetData, file = "./subsetDataOutput.csv", sep = ",", col.names = TRUE, row.names = FALSE);
    write.table(averageSubsetData, file = "./averageSubsetDataOutput.csv", sep = ",", col.names = TRUE, row.names = FALSE);
  }
}

## getTidyData reads in the data files, cleans and tidies them, subsets the mean and stdev data, and
##      merges the test and train data
## 
## argument: rootFileDir is the directory in which the "UCI HAR Dataset" folder exists
##
## ouptput:
##      dataSubset is the cleaned, tidied and subsetted data
getTidyData <- function(rootFileDir)
{
  if (!is.null(rootFileDir))
  {
    setwd(rootFileDir);
    
    activities <- data.table(read.table("./UCI HAR Dataset/activity_labels.txt"));
    setnames(activities, "V1", "activityid");
    setnames(activities, "V2", "activityname");
    
    features <- getFeatures();
    
    ## get the test and training data
    fullTest <- readTestFiles(activities, features);
    fullTrain <- readTrainFiles(activities, features);
    
    ## combine the test and training data by appending rows
    fullData <- bind_rows(fullTest, fullTrain);
    
    ## determine which columns are stdev or mean values
    subsetIndex <- grep("_std$|_std_|_mean$|_mean_", names(fullData))
    
    ## subset the data based upon the indices of the stdev and mean values
    dataSubset <- fullData[,c(1:2,subsetIndex)];
  }
}

## getAverageSubsetData takes the data from the previous function and provides averages of the variables
##    grouped by subject and activity type.
## 
## argument: subsetData is the subsetted data from getTidyData()
##
## ouptput:
##      averageSubsetData is the grouped and averaged data
getAverageSubsetData <- function(subsetData)
{
  if (!is.null(subsetData))
  {
    ## group the data together by subject and activity type
    groupedData <- group_by(subsetData, subjectid, activityname);
    
    ## get all the column names and the count
    columnNames <- names(groupedData);
    columnCount <- length(columnNames);
    
    ## while loop that creates a summarize command to get the mean for each column
    ## based upon the grouping by subject and activity type
    ## the summarize looks like 
    ##    summarize(groupedData, mean(tbodyacc_mean_x), mean(tbodyacc_mean_y), ...)
    i = 3;
    expression = "summarize(groupedData";
    while (i <= columnCount)
    {
      expression <- paste(expression, ",mean(", columnNames[i], ")");
      i = i + 1;
    }
    expression <- paste(expression, ")");
    
    ## execute the generated expression to get the mean value grouped by subject and activity
    averageSubsetData <- eval(parse(text=expression));
  }
}

## getFeatures reads in the features gathered for each subject, cleans the column names to remove
##      parentheses, commas, and hyphens, converting commas and hypens to underscores; names are lower
##      cased as well
## 
## ouptput:
##      features is the cleaned feature names
getFeatures <- function()
{
    features <- data.table(read.table("./UCI HAR Dataset/features.txt"))
    setnames(features, "V1", "featureid");
    setnames(features, "V2", "featurename");
    features$featurename = gsub("(", "", features$featurename, fixed = TRUE);
    features$featurename = gsub(")", "", features$featurename, fixed = TRUE);
    features$featurename = gsub("-", "_", features$featurename, fixed = TRUE);
    features$featurename = gsub(",", "_", features$featurename, fixed = TRUE);
    features$featurename = tolower(features$featurename);
    
    return(features);
}

## readTestFiles reads the test file data from a file, changes names to clearer names, and 
##      assigns the variables with the appropriate feature name
## 
## argument: 
##      activities is the list of activity ids and values
##      features is the names of the measurements
##
## ouptput:
##      fullTest is the tidied set of full test data
readTestFiles <- function(activities, features)
{
    subjectTest <- data.table(read.table("./UCI HAR Dataset/test/subject_test.txt"));
    setnames(subjectTest, "V1", "subjectid");
    
    xTest <- data.table(read.table("./UCI HAR Dataset/test/X_test.txt"));
    
    ## apply the feature names as the column names for the measurements
    colnames(xTest) <- as.character(features$featurename);
    
    yTest <- data.table(read.table("./UCI HAR Dataset/test/Y_test.txt"));
    setnames(yTest,"V1","activityid");
    
    ## join the data together by activity
    yTestActivities <- inner_join(activities, yTest, by="activityid");
    
    ## combine the data into one data frame based upon position
    fullTest <- data.frame(subjectTest, activityname = yTestActivities[,2], xTest);
}

## readTrainFiles reads the training file data from a file, changes names to clearer names, and 
##      assigns the variables with the appropriate feature name
## 
## argument: 
##      activities is the list of activity ids and values
##      features is the names of the measurements
##
## ouptput:
##      fullTrain is the tidied set of full training data
readTrainFiles <- function(activities, features)
{
    subjectTrain <- data.table(read.table("./UCI HAR Dataset/train/subject_train.txt"));
    setnames(subjectTrain, "V1", "subjectid");
    
    xTrain <- data.table(read.table("./UCI HAR Dataset/train/X_train.txt"));

    ## apply the feature names as the column names for the measurements
    colnames(xTrain) <- as.character(features$featurename);
    
    yTrain <- data.table(read.table("./UCI HAR Dataset/train/Y_train.txt"));
    setnames(yTrain,"V1","activityid");
    
    ## join the data together by activity
    yTrainActivities <- inner_join(activities, yTrain, by="activityid");

    ## combine the data into one data frame based upon position
    fullTrain <- data.frame(subjectTrain, activityname = yTrainActivities[,2], xTrain);
}

