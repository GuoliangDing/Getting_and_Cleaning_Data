setwd("C:/Users/kilading/Documents/RLearning/HAR_Dataset")
library(plyr)

# Step 1
# Merge the training and the test sets to create one data set
#------------------------------
#load training sets

training_data <- read.table(file = "train/X_train.txt")

training_subject <- read.table(file = "train/subject_train.txt", col.names = c("subjectID"))

training_activity <- read.table(file = "train/y_train.txt", col.names = c("activityID"))


#load test sets
test_data <- read.table(file = "test/X_test.txt")

test_subject <- read.table(file = "test/subject_test.txt", col.names = c("subjectID"))

test_activity <- read.table(file = "test/y_test.txt", col.names = c("activityID"))


# merge train and test sets
full_data <- rbind(training_data, test_data)

full_subject <- rbind(training_subject, test_subject)

full_activity <- rbind(training_activity, test_activity)
#------------------------------

# Step 2
# Extracts only the measurements on the mean and standard deviation for each measurement
#-----------------------------
features <- read.table(file = "features.txt", col.names = c("featureID","featureName"))

target_feature <- grepl("mean", features$featureName) | grepl("std", features$featureName)

target_feature_names <- features[target_feature, 2]

extracted_data <- full_data[, target_feature]
#------------------------------

# Step 3
# Uses descriptive activity names to name the activities in the data set
#-----------------------------
activity <- read.table(file = "activity_labels.txt", col.names = c("activityID","activityName"))

full_activity[, 1] <- activity[full_activity[, 1], 2]

colnames(full_activity) <- "activityName"
#------------------------------


# Step 4
# Appropriately labels the data set with descriptive variable names
#------------------------------

#rename the colnames in extracted_data
colnames(extracted_data) <- target_feature_names

#combine extracted_data, activity and subject
final_data <- cbind(full_subject, full_activity, extracted_data)
#------------------------------


# Step 5
# From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject.
#------------------------------
summary <- ddply(final_data, c("subjectID","activityName"), numcolwise(mean))
write.table(summary, file = "project_cleaned_data.txt", row.name=FALSE)
