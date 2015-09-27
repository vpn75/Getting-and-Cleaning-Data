library(plyr)

f <- read.table(file = "features.txt")

#Search for mean/std variables to be extracted
idx <- grep("-(mean|std)\\(", f$V2)

#Read in training data
x_train <- read.table(file = "train/X_train.txt")[idx]
y_train <- read.table(file = "train/y_train.txt")
train_subj <- read.table(file = "train/subject_train.txt")
acts <- read.table(file = "activity_labels.txt")

#Read in test data
x_test <- read.table(file = "test/X_test.txt")[idx]
y_test <- read.table(file = "test/y_test.txt")
test_subj <- read.table(file = "test/subject_test.txt")

#Set colnames for extracted columns in x_train data
colnames(x_train) <- f[idx,2]
newxtr <- cbind(train_subj, x_train)
newxtr <- cbind(y_train, newxtr)

#Set colname for Subject column to remove column name dupe
colnames(newxtr)[2] <- "Subject"

#Merge activity labels into training data
xtrwacts <- merge(acts, newxtr, by.x = "V1", by.y = "V1")

#Set colnames for extracted columns in x_train data
colnames(x_test) <- f[idx,2]
newxtst <- cbind(test_subj, x_test)
newxtst <- cbind(y_test, newxtst)

#Set colname for Subject column to remove column name dupe
colnames(newxtst)[2] <- "Subject"

#Merge activity labels into training data
xtstwacts <- merge(acts, newxtst, by.x = "V1", by.y = "V1")

#Merge training and test datasets
combined <- do.call(rbind, list(xtrwacts,xtstwacts))

colnames(combined)[1] = "Activity"

#Subset data on only activity, subject and mean() variables
colidx <- grep("(mean\\(\\)|Activity|Subject)", colnames(combined))
temp <- combined[colidx]

#Group by subject, activity but only take colmeans of means() columns
tidy <- ddply(temp, .(Subject,Activity), function(x) colMeans(x[3:ncol(x)]))

#Clean up colnames and re-assign to our tidy data
tidycols <- gsub("\\(\\)", "", colnames(tidy))
colnames(tidy) <- tidycols

#Write out tidy data out to csv file
write.table(tidy, file = "tidy_data.txt", quote = FALSE, sep = ",", row.names = FALSE)

