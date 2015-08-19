## Course project for "Getting and Cleaning Data": 
##    (1) Merge the test and training data sets from U.C. Irvine Human Activity Recognition project
##    (2) Extract the "mean" and "standard deviation" measurements
##    (3 & 4) Assign descriptive labels to activity values and to sensor data variables
##    (5) Calculate the average value of each selected measurement & place those results in a second tidy dataset


## Load the TEST tables of activity codes, subject IDs, and sensor data
     test_activ <- read.table("./test/y_test.txt")
     test_subj <- read.table("./test/subject_test.txt")
     test_data <- read.table("./test/X_test.txt")

## Load the TRAINING tables of activity codes, subject IDs, and sensor data
     train_activ <- read.table("./train/y_train.txt")
     train_subj <- read.table("./train/subject_train.txt")
     train_data <- read.table("./train/X_train.txt")

## Merge the TEST and TRAINING tables for activity codes, subject IDs, and sensor data
     all_activ <- rbind(test_activ,train_activ)
     all_subj <- rbind(test_subj,train_subj)
     all_data <- rbind(test_data,train_data)

## Identify those features (sensor measurements) that measure a mean or standard deviation
     feature_list <- read.table("features.txt")
     mean_rows <- grepl("mean()", feature_list[,2], fixed=TRUE)  ## Identifies the 33 variable names containing "mean()"
     std_rows <- grepl("std()", feature_list[,2], fixed=TRUE)    ## Identifies the 33 variable names containing "std()"
     pick_these <- which(mean_rows | std_rows)                   ## Creates a combined index vector to select those 66 variables

## Extract the mean and standard deviation measures from the sensor data table (66 columns out of 561)
     col_subset <- all_data[,pick_these]

## Replace activity codes (in activity table) with descriptive activity names
     all_activ[all_activ$V1==1,1] <- "WALKING"
     all_activ[all_activ$V1==2,1] <- "WALKING_UPSTAIRS"
     all_activ[all_activ$V1==3,1] <- "WALKING_DOWNSTAIRS"
     all_activ[all_activ$V1==4,1] <- "SITTING"
     all_activ[all_activ$V1==5,1] <- "STANDING"
     all_activ[all_activ$V1==6,1] <- "LAYING"

## Combine activity data, subject ID, and selected sensor data into a single dataset
     data_subset <- cbind(all_activ$V1, all_subj$V1, col_subset)

## Replace all the column headings with descriptive variable names
     feature_names <- as.vector(feature_list[pick_these,])
     col_heads <- as.character(feature_names$V2)
     colnames(data_subset) <- c("Activity","Subject_ID", col_heads)

## Load dplyr for the next step
     library(dplyr)
  
## Calculate average values for data grouped by each activity and each subject
     mean_set <- group_by(data_subset,Activity,Subject_ID) %>% 
          select(-(Activity:Subject_ID))  %>% 
               mutate_each(funs(mean))
     
## Reduce results to unique rows only; sort by Activity (in alphabetical order) and Subject_ID (1 to 30)
     mean_set <- unique(mean_set)
     mean_set <- arrange(mean_set, Activity, Subject_ID)
  
## For the new dataset, create new column names (other than Activity and Subject_ID) beginning with "Mean of"
     colnames_means <- character(length=66)
     for(i in 1:66) colnames_means[i] <- paste("Mean of", col_heads[i])
     colnames(mean_set) <- c("Activity","Subject_ID", colnames_means[1:66])

## Write the new dataset as a text file to be uploaded for evaluation
     write.table(mean_set, file="tidyset2.txt", row.names=FALSE)
     
## To load this file back into R:   read.table("tidyset2.txt", header=TRUE)