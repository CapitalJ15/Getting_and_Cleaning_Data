# Getting_and_Cleaning_Data
Course project to create and document a tidy data set

###Dataset

Human Activity Recognition database built from the recordings of 30 subjects performing six different activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) while carrying a waist-mounted Samsung Galaxy S II smartphone with embedded inertial sensors. The experimental results were randomly partitioned into two sets, with 70% of the volunteers generating the training data, and the other 30% generating the test data.

*Data source:* University of California, Irvine (UCI)

###Description of R script run_analysis.R:

* The three test datasets (2947 rows each) and the three training datasets (7352 rows each) supplied by UCI are combined using rbind to make three datasets: activity codes (10,299 rows x 1 column), subject IDs (10,299 rows x 1 column), and feature data (10,299 rows x 561 columns).

* The derived variables for mean value and standard deviation, represented by appending “mean()” or “std()” to the variable name along with the axial direction, are extracted from the list of 561 variables in the feature vector. There are 33 of each, for a total of 66 variables. (For a list of these variables, see Section 8 of the Codebook.) Selecting these columns from the feature data file yields a new file with 10,299 rows and 66 columns.

* The integer activity codes are replaced with the matching descriptive activity names (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).

* The activity data, subject ID, and selected feature data are combined using cbind into a single dataset of 10,299 rows x 68 columns. The first two columns are labeled “Activity” and “Subject_ID.” The remaining column labels are the 66 features containing either “mean()” or “std()” in their names.

* The dplyr package was used to create the second dataset as instructed in step 5.

* The data are grouped by activity and subject, and the averages (means) within each group are calculated for each of the 66 “mean()” or “std()” features. The results are reduced to a wide-form tidy dataset of unique values consisting of 180 rows (30 subjects x 6 activities) and 68 columns (“Activity,” “Subject_ID,” and the 66 previously selected features). New feature column labels with the prefix “Mean of” are attached. This dataset of averages is named tidyset2.txt.

* To load the tidy dataset back into R, use the following code:  **read.table("tidyset2.txt", header=TRUE)**

