## Code Book for Course Project

### Overview

[Source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) of the original data:

	https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

[Full Description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) at the site where the data was obtained:

	http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
	
### Process

The script `run_analysis.R` performs the following process to clean up the data
and create tiny data sets:

1. Reads the training and test sets to merge them into one data set.

2. Reads tables with subjects, activities, and features information.

3. Merges them into one dataset. Uses only measurements on the mean and standard
   deviation for each measurement.

4. Makes descriptive activity and subject names.

5. Appropriately label the data set with descriptive variable names.

6. Creates a dataset with mean of each mesurment for each activity and each subject. Result is in `Tidy.txt`.

### Variables

- features - feature names from `features.txt`
- activity_labels - activity labels from `activity_labels.txt`
- y_train - training labels from `train/y_train.txt`
- x_train - training set from `train/X_train.txt`
- y_test - training labels from `test/y_test.txt`
- x_test - training set from `test/X_test.txt`
- subject_test - table contents of `test/subject_test.txt`
- subject_train - table contents of `train/subject_train.txt`
- activity - merged training labels from train and test data set
- rawdata - merged train and test sets from train and test data set
- person - merged column with subjects from train and test data set
- dataset - merged subjects with activities with measurements
- meandata - average of each variable for each activity and each subject from dataset

### Output

#### Tidy.txt

`Tidy.txt` is a 180*81 data frame.

- The first column contains Subject IDs (`Person`).
- The second column contains activity names (`Activity`).
- The last 79 columns are measurements.
- `Person` is factor variable with levels `Person 1` to `Person 30`.
- `Activity` is a factor variable with 6 factors (originally from activity_labels.txt)
