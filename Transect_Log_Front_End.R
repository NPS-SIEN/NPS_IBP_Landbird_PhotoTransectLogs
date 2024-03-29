############################# Overview ################################### 
##
## Project: NPS IBP Landbird Photo Transect Logs
## Purpose: To output a list of photo and file locations needed for the 
##          photo transect log
## Date: 10/25/2022
## Author: Sarah Wakamiya, SIEN Data Manager
## R version written for: 4.2.0
##
################## ALT-O to collapse all ################################# 

## This short script will guide you through the steps to create the photo transect log PDF files. Please follow all the steps carefully!

# Step 1: Make sure that you have launched the project properly by opening the  NPS_IBP_Landbird_PhotoTransectLogs.Rproj file, and then opening this script through the R studio Files panel (usually on the lower right hand side of the screen). This will set the folder structure up properly. Check where the directory starts by running:
here::here()

# Step 2: download a copy of the database back end, and place it in the INUT_DATA folder in the project

# Step 3: Make sure that you have all these libraries installed before proceeding:

#------------------------ Libraries -------------------------------------#
library(RODBC)#v1.3-1.9
library(dplyr)#v1.0.9
library(tidyr)#v1.2.0
library(here) #v1.0.1 
library(lubridate)#v1.8.0
library(stringr)#v1.4.0
#------------------------------------------------------------------------#

# Step 4: Please enter the following parameters, and check the spelling carefully as R is case sensitive!

#------------------------ Parameters ------------------------------------#

# the exact filename of the database that was copied into the INPUT_DATA folder:
db_name <- "SIEN_Landbirds.accdb"

# The sampling year for the photo logs:
year<-2022

# the panel codes for the photo logs. Include each required panel name separated by a comma
panel_list <- c(1,4)

# The server filepath (up to the park subfolder) that contains your photos (dont forget to use double backslashes): 
server_filepath <-"C:\\Users\\EEdson\\Pictures\\Saved Pictures" 
 
#------------------------------------------------------------------------#

# Step 5: load the functions into your local environment by running this line of code unaltered:
for(script in list.files(here::here("R_CODE", "data_wrangling_functions"))){
  source(here::here("R_CODE", "data_wrangling_functions",script))
}

# Step 6: run the following function unaltered
image_table <- create_transect_log(db_name, year, panel_list, server_filepath )

# And that's it! 
# There should now be a seperate PDF for each park, of all the photos for the transects to be surveyed for the current year
