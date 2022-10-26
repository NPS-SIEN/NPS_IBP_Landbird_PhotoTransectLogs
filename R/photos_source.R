#############################Overview ################################### 
##
## Project: NPS IBP Landbird Photo Transect Logs
## Purpose: To output a list of photo and file locations needed for the 
##          photo transect log
## Date: 10/25/2022
## Author: Sarah Wakamiya, SIEN Data Manager
## R version written for: 4.2.0
##
##################ALT-O to collapse all ################################# 

#------------------------ Libraries -------------------------------------#
library(RODBC)#v1.3-1.9
library(raster)#v3.5-21
library(dplyr)#v1.0.9
library(tidyr)#v1.2.0
library(here) #v1.0.1 
library(lubridate)#v1.8.0
library(stringr)#v1.4.0
#------------------------------------------------------------------------#

#------------------------ Parameters ------------------------------------#
#Enter the server filepath that contains your photos up to the park subfolder
server_filepath <-"SERVER/FILEPATH" 

#Enter the sampling year for the photo logs
year<-2022 
#------------------------------------------------------------------------#

#check where the working directory is
here::dr_here()

##Connect to the landbird database - ensure it is in the data subfolder of your working directory
filepath <- here("data", "SIEN_Landbirds_BackEnd_20221025_Test.accdb")
connection <- odbcConnectAccess2007(filepath)

#get sampling schedule
schedule<-sqlQuery(connection, "SELECT tbl_Schedule.Calendar_year, tbl_Sites.Park_code, tbl_Sites.Site_code
FROM tbl_Sites INNER JOIN tbl_Schedule ON tbl_Sites.Site_ID = tbl_Schedule.Site_ID ORDER BY tbl_Sites.Park_code, tbl_Sites.Site_code;") %>%
  filter(Calendar_year==year)

#get images from database
images<-sqlQuery(connection, "SELECT tbl_Locations.Park_code, tbl_Sites.Site_code, tbl_Locations.Location_code, tbl_Features.Feature_ID, tbl_Features.Feature_desc, tbl_Images_proposed.*
FROM tbl_Sites INNER JOIN ((tbl_Locations INNER JOIN tbl_Images_proposed ON tbl_Locations.Location_ID = tbl_Images_proposed.Location_ID) LEFT JOIN tbl_Features ON tbl_Images_proposed.Feature_ID = tbl_Features.Feature_ID) ON tbl_Sites.Site_ID = tbl_Locations.Site_ID
ORDER BY tbl_Locations.Park_code, tbl_Sites.Site_code, tbl_Locations.Location_code;")

#filter images for transect photo sheet and create filepath
transect_images<-images %>%
  filter(Is_Active==TRUE) %>%
  mutate(image_date = ymd(str_sub(Image_filename, 1, 8)),
         filepath = str_c(server_filepath, Park_code, Image_filename, sep="/"))