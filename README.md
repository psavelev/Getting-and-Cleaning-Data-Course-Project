# Getting and Cleaning Data Course Project

This is the final Getting an Cleaning Data Course project.

The data preparation script is implemented in **run_analysis.R**, which does the following:

1. Downloads dataset from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unpack it
2. Reads "dictionary" data: list of activities (activity_labels.txt) and list of features (features.txt)
3. Creates vectors with features and their approprate names which contaits 'mean' and 'std'. They will be used to select the only data whcih containts mean and standard deviations from the datasets.
4. Reads Testing and training datasets, mearges botth datasets to one. Appropriately labels the data set with descriptive variable names are used. Descriptive activity names are set in the data set
5. Creates independent tidy data set with the average of each variable for each activity and each subject.
6. Saves tidy dataset to FUCI_HAR_Dataset_Tidy.csv (which is submitted to Coursera)

The original dataset was published by:

        Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
        Smartlab - Non Linear Complex Systems Laboratory
        DITEN - Universit? degli Studi di Genova.
        Via Opera Pia 11A, I-16145, Genoa, Italy.
        activityrecognition@smartlab.ws
        www.smartlab.ws



