# Set the working directory to where the data is located
setwd("C:\Users\pshre\Downloads\getdata_projectfiles_UCI HAR Dataset\UCI HAR Dataset")

# Load data
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# Load feature names
features <- read.table("features.txt")

# Load activity labels
activity_labels <- read.table("activity_labels.txt")

# Combine the training and test data
X_data <- rbind(X_train, X_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Extract the feature names (column names)
feature_names <- features$V2

# Get the indices for columns that are related to mean or std
mean_std_indices <- grep("mean\\(\\)|std\\(\\)", feature_names)

# Subset the data to only include mean and standard deviation columns
X_data <- X_data[, mean_std_indices]

# Assign the column names
names(X_data) <- feature_names[mean_std_indices]
# Add descriptive activity names
y_data$activity <- activity_labels$V2[y_data$V1]

# Combine the data into one dataset
merged_data <- cbind(subject_data, y_data$activity, X_data)

# Rename columns to something more descriptive
names(merged_data)[1] <- "subject"  # subject ID
names(merged_data)[2] <- "activity"  # activity name
# Load the dplyr package
library(dplyr)

# Create a tidy dataset with the average of each variable for each activity and subject
tidy_data <- merged_data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

# Write the tidy data to a file
write.table(tidy_data, "tidy_data.txt", row.name = FALSE)


