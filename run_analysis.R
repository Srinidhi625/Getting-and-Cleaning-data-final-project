require('data.table')
require('reshape2')
activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt')[,2]
features <- read.table('./UCI HAR Dataset/features.txt')[,2]
test_x <- read.table('./UCI HAR Dataset/test/X_test.txt')
test_y <- read.table('./UCI HAR Dataset/test/y_test.txt')
test_subject <- read.table('./UCI HAR Dataset/test/subject_test.txt')
train_x <- read.table('./UCI HAR Dataset/train/X_train.txt')
train_y <- read.table('./UCI HAR Dataset/train/y_train.txt')
train_subject <- read.table('./UCI HAR Dataset/train/subject_train.txt')

names(test_x) = features
names(train_x) = features

extract_only_measurements <- grep('mean|std', features)

test_x = test_x[,extract_only_measurements]
train_x = train_x[,extract_only_measurements]

test_y[,2] = activity_labels[test_y[,1]]
names(test_y) = c('Activity_ID','Activity_Label')
names(test_subject) = 'subject'

train_y[,2] = activity_labels[train_y[,1]]
names(train_y) = c('Activity_ID', 'Activity_Label')
names(train_subject) = 'subject'

test_data <- cbind(as.data.table(test_subject), test_x, test_y)
train_data <- cbind(as.data.table(train_subject), train_x, train_y)

data <- rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data  = melt(data, id = id_labels, measure.vars = data_labels)

tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt", row.names = FALSE)

