# DataCleaningProject
===========

This is the course project for the Getting and Cleaning Data Course. It takes a set of fitness tracking data, tidies it, subsets it, and calculates some averages. The files contained in the project are as follows:
* Raw data files: all files in the "UCI HAR Dataset" folder. These contain a README.txt file describing the raw files.
* Processed data files: subsetDataOutput.csv and averageSubsetDataOutput.csv.
* Code book: CodeBook.md 
* Script: runAnalysis.R, which contains pseudo-code for how the data is processed

Running the script
===========
To run the script, clone this repository locally, and make sure you have sourced the appropriate R libraries:
* dplyr
* data.table

You'll need to source the code in runAnalysis.R, and then call the produceCleanedData() function. This function takes the root directory of your repo as an argument and outputs the processed data files in that directory.

Files output
===========
subsetDataOutput.csv is the first file produced. It reads in all of the test and training data from the raw data, combines all the data correctly, cleans up names, and pulls out the measurements that are means or standard deviations. 

averageSubsetDataOutput.csv is produced from the data in subsetDataOutput.csv. It provides the average of each measurement, grouped by subject and activity type.
