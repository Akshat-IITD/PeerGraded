library(dplyr)
library(plyr)
#if (!file.exists("./data")){dir.create("./data")}
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "./data/acc.zip")
#unzip("./data/acc.zip")

test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")

data <- rbind(test_data, train_data)
#data <- tbl_df(data)

test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")

labels <- rbind(test_labels, train_labels)
#labels <- tbl_df(labels)

test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

subject <- rbind(test_subject, train_subject)
#subject <- tbl_df(subject)

activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
#features <- tbl_df(features)

numbers <- features[grep("mean\\(\\)|std\\(\\)", features$V2), 1]
names <- features[grep("mean\\(\\)|std\\(\\)", features$V2), 2]
numbers_V <- gsub("(.*)", "V\\1", numbers)

data <- select(data, numbers_V)

tmp <- join(labels, activities)
labels <- select(tmp, V2)

data <- cbind(subject, labels, data)
names(data) <- c("Subject", "Activity", names)

data_tmp <- tbl_df(data)
data_tmp <- group_by(data, Subject, Activity)
mean_data <- summarise_all(data_tmp, mean)