library(dplyr) # for bind_cols
library(stats) # for aggregate function

# Reading train and test data sets, features, labels and subjects
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

## Mergeing test and train data sets, removing variables we do not need
activity <- rbind(y_train, y_test)
rawdata <- rbind(x_train, x_test)
person <- rbind(subject_train, subject_test)
rm(y_train, y_test, x_train, x_test, subject_train, subject_test)

## Prepare data sets for merging
names(rawdata) <- features #Setting column names from features

## Extract the measurements on the mean and standard deviation
rawdata <- rawdata[,names(rawdata[grepl("std|mean",names(rawdata))])]

## Merging tables. Remove variables used.
dataset <- bind_cols(person, activity, rawdata)
rm(person, activity, rawdata)

## Make descriptive activity names, and subject numeration (as factor Person 1 to Person 30).
#Remove variables used.
dataset$Activity <- factor(dataset$Activity)
dataset$Person <- factor(dataset$Person)
levels(dataset$Activity) <- levels(activity_labels)
levels(dataset$Person) <- paste("Person",1:30)
rm(activity_labels, features)

## Label the data set with descriptive variable names.
#I didn't edit function names because they are already descriptive,
#accelerometer and gyroscope description would make column names too long.
names(dataset) <- gsub("^t", "Time", names(dataset))
names(dataset) <- gsub("^f", "Frequency", names(dataset))
names(dataset) <- gsub("(Body){2}", "Body", names(dataset))

## Create a dataset with mean of each mesurment for each activity and each subject.
# Export tidy dataset into file Tidy.txt.
meandata <- aggregate(. ~Person + Activity, dataset, mean)
write.table(x = meandata, file = "../Tidy.txt", row.names = FALSE)
