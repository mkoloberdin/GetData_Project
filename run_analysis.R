# Auxiliary function to process one dataset
# (the dataset parameter should be either "test" or "train")
# Returns processed data as described in the comments below
processDataSet <- function(dataset) {
    setDir <- file.path(baseDir, dataset)
    setFilename <- file.path(setDir, paste0("X_", dataset, ".txt"))
    df <- read.table(unz(localZipFile, setFilename))
    
    # Apply the descriptive feature names to columns
    colnames(df) <- featureNames
    
    # Read in and add the subject column, as integers for now
    # (will be converted to factor after merging all data)
    subjFilename <- file.path(setDir, paste0("subject_", dataset, ".txt"))
    subjDF <- read.table(unz(localZipFile, subjFilename),
                         colClasses = c("integer"))
    df$subject <- subjDF[,1]
    
    # Read in and add the activity column, as integers for now
    # (will be converted to factor after merging all data)
    actFilename <- file.path(setDir, paste0("y_", dataset, ".txt"))
    actDF <- read.table(unz(localZipFile, actFilename),
                        colClasses = c("integer"))
    df$activity <- actDF[,1]
    
    # Extract only the measurements on the mean and standard deviation
    # for each measurement.
    # The assignment is not very clear on which columns to keep. Most
    # likely the ones that end in mean/std()-X/Y/Z. Such measurements
    # appear to be parts of groups of measurements (different kinds of
    # calculations on the same measured values), so it makes sense
    # that a need to pick certain kinds of values from those groups
    # might arise.
    # Besides the rest of the values that contain the word "mean" are
    # either different metrics on the same group
    # (e.g. fBodyAcc-meanFreq()-X) or derivated values of other metrics
    # which already have ...-mean()/...-std() values
    # So, let's stick to "uniform" ...-mean()/...-std() columns.
    allCols <- colnames(df)
    colsToKeep <- allCols[grepl("mean\\(|std\\(", allCols)]
    # Also keep subject and activity columns
    colsToKeep <- append(colsToKeep, c("subject", "activity"))
    df <- df[, colsToKeep]
    
    df
}

# Set up some globals

# Source data URL
sourceURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# File name of the local data (zip)
localZipFile <- "UCI HAR Dataset.zip"

# Base location of the data (base path)
baseDir <- "UCI HAR Dataset"

# Download source data if it does not exist in the working directory
if(!file.exists(localZipFile)) {
    download.file(sourceURL, localZipFile, mode="wb")
}

# Read feature names
featuresFilename <- file.path(baseDir, "features.txt")
featureNames <- read.table(unz(localZipFile, featuresFilename),
                           colClasses = c("integer", "character"))
# Keep only the names of the features
# (they are ordered, so column #1 duplicates the row index)
featureNames <- featureNames[,2]

# Read the activity names
actFilename <- file.path(baseDir, "activity_labels.txt")
actLabels <- read.table(unz(localZipFile, actFilename),
                        colClasses = c("integer", "character"))

# Read and process training dataset
df <- processDataSet("train")
# Read and process test dataset
df2 <- processDataSet("test")

# Merge (append one to the other) the two datasets
df <- rbind(df, df2)

# Convert "subject" and "activity" columns to factors
df$subject <- as.factor(df$subject)
# For "activity" we need to apply the descriptive names first
for (l in 1:nrow(actLabels)) {
    df[df$activity == actLabels[l, 1], "activity"] <- actLabels[l, 2]
}
df$activity <- as.factor(df$activity)

# Save the generated dataset
write.table(df, "combined_data.txt", row.names=FALSE)

# Create a second, independent tidy data set with the average of each
# variable for each activity and each subject. 
tidyDF <- aggregate(. ~ activity + subject, data=df, mean)
# Save the second (tidy) dataset
write.table(tidyDF, "tidy_data.txt", row.names=FALSE)
