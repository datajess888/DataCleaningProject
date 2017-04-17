Code Book 
===========

This code book describes the data files output by the script in this repo. The output files are as follows:
* subsetDataOutput.csv: this file is the combined test and training data, cleaned and subsetted to provide only mean and standard deviation values
* averageSubsetDataOutput.csv: this file takes the data in subsetDataOutput.csv and provides a mean for each measurement column, grouped by subject and activity type

subsetDataOutput.csv
===========
The data in this file is subsets of data from the features provided in the raw data. See the [Feature Selection section](https://github.com/datajess888/DataCleaningProject/new/master#feature-selection) for details on thes values. Note that "-" (hyphens) were changed to "_" (underscores) when setting column names.

averageSubsetDataOutput.csv
===========
The data in this file is a mean of all the values for each feature, grouped by subject and activity type. The columns are named with mean(feature_name), so it is clear which feature has been averaged.

Feature Selection
===========
This information is directly from the features_info.txt file:
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ

tGravityAcc-XYZ

tBodyAccJerk-XYZ

tBodyGyro-XYZ

tBodyGyroJerk-XYZ

tBodyAccMag

tGravityAccMag

tBodyAccJerkMag

tBodyGyroMag

tBodyGyroJerkMag

fBodyAcc-XYZ

fBodyAccJerk-XYZ

fBodyGyro-XYZ

fBodyAccMag

fBodyAccJerkMag

fBodyGyroMag

fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value

std(): Standard deviation
