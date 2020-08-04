library(dplyr)
library(tidyr)

# Data initialization
urlDataset <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
nameFileArchive <- "FUCI_HAR_Dataset.zip"
nameDataDirectory <- "data"
nameDataUCIDirectory <- paste(nameDataDirectory, "UCI\ HAR\ Dataset", sep = "/")
nameFileTidyDataset <- paste(nameDataDirectory, "FUCI_HAR_Dataset_Tidy.txt", sep = "/")

# Reads specified datasets, bind data to one dataframe
# Parameters:
#       nameFileData - relative file path to the file with data set
#       nameFileActivities - relative file path to the file with labels data
#       nameFileSubjects - relative file path to the file with data related to subject 
#                       who performed the activity (IDs in range from 1 to 30)
#       columnsList - columns to be selected from nameFileAll dataset
#       columnsNames - the names of columns which are specified by columnsList vector
# Returns dataset
readData <- function (nameFileData, nameFileActivities, nameFileSubjects, 
                     columnsList, columnsNames, dtActivitiesList) {
        
        # Read  dataset
        dtData <- read.table(paste(nameDataUCIDirectory, nameFileData, sep = "/"))
        dtActivities <- read.table(paste(nameDataUCIDirectory, 
                                         nameFileActivities, sep = "/"))
        dtActivities$ActivityName = as.factor(dtActivitiesList$Activity[dtActivities[,1]])
        dtSubjects <- read.table(paste(nameDataUCIDirectory, 
                                       nameFileSubjects, sep = "/"))
        dt <- cbind(dtActivities$ActivityName, dtSubjects, dtData[, columnsList])
        colnames(dt) <- c("Activity", "Subject", columnsNames)
        
        dt
}

# Prepare dataset

# Check if archived dataset file is not existing in work directory, then download it
if (!file.exists(nameFileArchive)) {
        download.file(urlDataset, nameFileArchive)
}
# Unzip dataset from archive, overwrite existing files
unzip(nameFileArchive, exdir = nameDataDirectory)

# Read "dictionary" data
dtActivities <- read.table(paste(nameDataUCIDirectory, "activity_labels.txt", 
                               sep = "/"), stringsAsFactors = FALSE)
colnames(dtActivities) <- c("Code", "Activity")
dtFeatures <- read.table(paste(nameDataUCIDirectory, "features.txt", 
                              sep = "/"), stringsAsFactors = FALSE)
colnames(dtFeatures) <- c("Code", "Feature")

# Get vector of features containing mean and std (Standard Distribution) values
features <- grep(".(mean|std).", dtFeatures$Feature)
# Get names of the feature and make values suitable (remove -, () chars) for column naming
featureNames <- dtFeatures[features, "Feature"]

# Read and merge datasets
dtTraining <- readData("train/X_train.txt", "train/Y_train.txt", 
                       "train/subject_train.txt", features, featureNames,
                       dtActivities)
dtTesting <- readData("test/X_test.txt", "test/y_test.txt", 
                      "test/subject_test.txt", features, featureNames,
                      dtActivities)
dtAll <- as_tibble(rbind(dtTraining, dtTesting))
rm(dtTraining, dtTesting)

# Create Tidy dataset with the average of each variable for each activity and each subject.
dtTidy <- dtAll %>% 
        gather(key = "Variable", value = "Value", -Activity:-Subject) %>% 
        group_by(Activity, Subject, Variable) %>% 
        summarise(mean(Value))

write.table(dtTidy, file = nameFileTidyDataset, row.names=FALSE)
