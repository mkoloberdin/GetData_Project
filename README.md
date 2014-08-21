# Getting and Cleaning Data Course Project

**`run_analysis.R`** script does the following:

1. Downloads the raw data zip file if a local copy not present in the working directory.
2. Loads training and test data sets one after the other and for every one of the two datasets:
    1. Applies descriptive feature names to columns. (from features.txt)
    2. Reads subject id data from corresponding files and adds it as a column to the data set.
    3. Reads activity data from corresponding files and adds it as a column to the data set.
    4. Keeps only the measurements on the mean and standard deviation for each measurement and
    discards the rest.
3. Merges the two data sets into one.
4. Applies descriptive activity names to name the activities in the data set. (from activity_labels.txt)
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. Saves it as "tidy_data.txt" (created with `write.table()` using `row.names=FALSE`)

[Code Book](CodeBook.md) describes the resultant data set in detail.

------------------------
### Assignment checklist
You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set. (✓ "3" above)
2. Extracts only the measurements on the mean and standard deviation for each measurement. (✓ "2.4" above)
3. Uses descriptive activity names to name the activities in the data set (✓ "4" above)
4. Appropriately labels the data set with descriptive variable names. (✓ "2.1" above)
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. (✓ "5" above)
