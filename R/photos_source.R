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
#------------------------------------------------------------------------#

#check where the working directory is
here::dr_here()

##Connect to the landbird database - ensure it is in the data subfolder of your working directory
filepath <- here("data", "SIEN_Landbirds_BackEnd_20221025_Test.accdb")
connection <- odbcConnectAccess2007(filepath)