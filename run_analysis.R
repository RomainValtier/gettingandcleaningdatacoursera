# 0. Get data from source

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileNAME <- "UCI_HAR_Dataset.zip"
download.file(fileURL, fileNAME)
unzip(fileNAME)

# 1. Merges the training and the test sets to create one data set
x.train <- read.table("./UCI HAR Dataset/train/X_train.txt")
x.test <- read.table("./UCI HAR Dataset/test/X_test.txt")
x.data <- rbind(x.train, x.test)

y.train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y.test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y.data <- rbind(y.train, y.test)

subject.train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject.test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject.data <- rbind(subject.train, subject.test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features.data <- read.table("./UCI HAR Dataset/features.txt")
mean.std <- grep("-mean\\(\\)|-std\\(\\)", features.data[, 2])
x.data.mean.std <- x.data[, mean.std]


# 3. Uses descriptive activity names to name the activities in the data set.
activities.data <- read.table("./UCI HAR Dataset/activity_labels.txt")
activities.data[, 2] <- tolower(as.character(activities.data[, 2]))
activities.data[, 2] <- gsub("_", "", activities.data[, 2])
y.data[, 1] = activities.data[y.data[, 1], 2]

# 4. Appropriately labels the data set with descriptive variable names.
colnames(y.data) <- 'activity'
colnames(subject.data) <- 'subject'
names(x.data.mean.std) <- features.data[mean.std, 2]
names(x.data.mean.std) <- tolower(names(x.data.mean.std))
names(x.data.mean.std) <- gsub("\\(|\\)", "", names(x.data.mean.std))

data <- cbind(y.data, subject.data, x.data.mean.std)
#str(data)
#write.table(data, "./UCI HAR Dataset/tidydata_merged.txt", row.names = FALSE)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library("dplyr")
data.mean.byactivity.bysubject <- data %>% group_by(activity, subject) %>% summarise_at(vars(-activity, -subject), funs(mean(., na.rm=TRUE)))
str(data.mean.byactivity.bysubject)
write.table(data.mean.byactivity.bysubject, "./UCI HAR Dataset/tidydata_average.txt", row.names = FALSE)
