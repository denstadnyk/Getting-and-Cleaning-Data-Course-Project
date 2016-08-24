## Readme for Getting and Cleaning Data Course Project

### Overview
## `run_analysis.R` does the following:
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names.
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


### Sources
[Source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) of the original data:

	https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

[Full Description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) at the site where the data was obtained:

	http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
	
### Get prepared tidy data that can be used for later analysis

1. Download the data and put in a working directory into folder `UCI HAR Dataset`.

2. Put **`run_analysis.R`** into your work directory.

3. Run `source("run_analysis.R")`. Tidy data set will be in your working directory, named **`Tidy.txt`**

### Process

Load libraries
````
library(dplyr) # for bind_cols
library(stats) # for aggregate function
````

Reading train and test data sets, features, labels and subjects
````
setwd("./UCI HAR Dataset/")
features <- read.table("./features.txt", header = FALSE)[[2]] # read only column with names
activity_labels <- read.table("./activity_labels.txt",
                              header = FALSE)[[2]] # read only column with labels
							  
# Train data set
y_train <- read.table("./train/y_train.txt", header = FALSE, col.names = "Activity")
x_train <- read.table("./train/X_train.txt", header = FALSE)
subject_train <- read.table("./train/subject_train.txt", header = FALSE, col.names = "Person")


# Test data set
y_test <- read.table("./test/y_test.txt", header = FALSE, col.names = "Activity")
x_test <- read.table("./test/X_test.txt", header = FALSE)
subject_test <- read.table("./test/subject_test.txt", header = FALSE, col.names = "Person")
````

Mergeing test and train data sets, removing variables we do not need
````
activity <- rbind(y_train, y_test)
rawdata <- rbind(x_train, x_test)
person <- rbind(subject_train, subject_test)
rm(y_train, y_test, x_train, x_test, subject_train, subject_test)
````

Setting column names from features
````
names(rawdata) <- features
````

Extract the measurements on the mean and standard deviation
````
rawdata <- rawdata[,names(rawdata[grepl("std|mean",names(rawdata))])]
````

Merging tables. Remove variables used.
````
dataset <- bind_cols(person, activity, rawdata)
rm(person, activity, rawdata)
````

Make descriptive activity names, and subject numeration (as factor `Person 1` to `Person 30`). Remove variables used.
````
dataset$Activity <- factor(dataset$Activity)
dataset$Person <- factor(dataset$Person)
levels(dataset$Activity) <- levels(activity_labels)
levels(dataset$Person) <- paste("Person",1:30)
rm(activity_labels, features)
````

Label the data set with descriptive variable names. I didn't edit function names because they are already descriptive, accelerometer and gyroscope description would make column names too long.
````
names(dataset) <- gsub("^t", "Time", names(dataset))
names(dataset) <- gsub("^f", "Frequency", names(dataset))
names(dataset) <- gsub("(Body){2}", "Body", names(dataset))
````

Create a dataset with mean of each mesurment for each activity and each subject. Export tidy dataset into file `Tidy.txt`.
````
meandata <- aggregate(. ~Person + Activity, dataset, mean)
write.table(x = meandata, file = "./Tidy.txt", row.names = FALSE)
````



#### Tidy.txt

`Tidy.txt` is a 180*81 data frame.

- The first column contains Subject IDs (`Person`).
- The second column contains activity names (`Activity`).
- The last 66 columns are measurements.
- `Person` is factor variable with levels `Person 1` to `Person 30`.
- `Activity` is a factor variable with 6 factors (originally from activity_labels.txt)
