# CodeBook for Getting-and-Cleaning-Data Course project

##Raw Data
The raw data for this project is accelerometer data collected from the Samsung Galaxy S smartphone and was provided through the links below:

Data file: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
CodeBook: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
This data included both the raw sampled data (folder ../Inertial Signals) and features apparently based on the raw data. For the purpose of this project, I am only looking at the features, not the raw data.

There are 3 types of files:

x: rows of feature measurements
y: the activity labels corresponding to each row of X. Encoded as numbers.
subject: the subjects on which each row of X was measured. Encoded as numbers.
In addition, to determine which features are required, we look at the list of features:

features.txt

The encoding from activity labels ids to descriptive names.

activity_labels.txt

## Data Load
* The Y, S and X data is loaded from each of the training and test datasets, directly as their final type.
* Only the columns of interest from X are loaded, that is the mean() and sd() columns. We determine the columns by examining the feature names (from features.txt) for patterns “-mean()” or “-std()”.
All of these files are fixed format text files.

##Transformation
1. The subject data along with the activity labels are added to the both training and test data sets.
2. Both training and test data sets are concatenated together.
3. Descriptive activity labels are merged into combined data set.

The combined dataset is further subsetted by selecting only the columns with "mean()" in the column names. Then we use ddply() from dplyr library to group data by combination of subject and activity and calculate the means of the mean() columns using colMeans. The column names are then further cleaned up by removing the "()" in names before outputting as tidy data comma-separated text file using write.table() with no row-names.
