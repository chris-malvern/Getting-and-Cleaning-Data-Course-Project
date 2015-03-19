
library(dplyr)

	# need UCI HAR Dataset in working directory

	# import data
xtrain <- read.table("UCI HAR Dataset/train/X_Train.txt")
xtest <- read.table("UCI HAR Dataset/test/X_Test.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
sbtrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
sbtest <- read.table("UCI HAR Dataset/test/subject_test.txt")
act_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

	# combine test & train 
data_mix <- rbind(xtrain, xtest)		
activity_mix <- rbind(ytrain, ytest)
subject_mix <- rbind(sbtrain, sbtest)

	# swap out activity code numbers for words
act_labels <- gsub('[0-9] ', '', act_labels$V2)
activity_mix <- apply(activity_mix, 2, function(x){ act_labels[x] } )	

	# get what will be column names
features <- read.table("UCI HAR Dataset/features.txt")	
	# pick out items containing std() mean() 
keep <- grep('std\\(\\)-|mean\\(\\)-', features$V2)		
	# chop () out, replace - with _, add names for 2 extra cols
feat_names <- gsub('\\(\\)', '', features$V2[keep])
feat_names <- gsub('-', '_', feat_names)  
feat_names <- c('subject', 'activity', feat_names)

	# eject unwanted cols
data_mix <- data_mix[, keep]		# eject non-mean,sd rows. 
				
	# add subject and activity cols
data_mix <- cbind(subject=subject_mix, activity=activity_mix, data_mix)
colnames(data_mix) <- feat_names		# now dim() is 10299  50

	# now make summary with dplyr
dm <- tbl_df(data_mix)
dm2 <- dm %>% unique %>% group_by(subject, activity) %>% summarise_each(funs(mean))

write.table(dm2, file='summary_samsung_data.txt', row.name=FALSE); closeAllConnections()
