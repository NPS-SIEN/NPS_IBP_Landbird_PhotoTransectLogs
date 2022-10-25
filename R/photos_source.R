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
#------------------------------------------------------------------------#

#check where the working directory is
here::dr_here()

