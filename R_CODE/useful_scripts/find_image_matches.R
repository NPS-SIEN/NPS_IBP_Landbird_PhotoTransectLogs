###################################################### Overview ##########
## Project: SIEN Landbird image filenames
## Purpose: to compare filenames in the database with those on the server
## Date: 2023-01-09
## Author: L Edson
## R version written for: 4.2.1
############################################ ALT-O to collapse all #######


#------------------------ Libraries -------------------------------------#
library(stringr) #v.1.4.1
library(dplyr) #v1.0.10
library(tidyr)
library(readr)
#------------------------------------------------------------------------#

#------------------------ Variables -------------------------------------#
# export of the tbl_Images from the database as a csv
image_tbl <- "tbl_Images.csv"
# table of just the filepaths/names file exported from the server as a csv
image_filenames <- "photocount_export.csv"
#------------------------------------------------------------------------#

#--------------------------------------------------- read in csv's ------

# note you will need to change the filepath to the files
images <- readr::read_csv(paste0("../",image_tbl),
                          col_types = "nncccncclccn")

image_names <- readr::read_csv(paste0("../",image_filenames),
                               col_types = "c",
                               col_names = c("FilePath"))

#------------------------------------clean up the image filenames ------

# filter the image names to the jpg strings and seperate max 3 times
image_names_jpg <- image_names %>% 
  dplyr::filter(
    stringr::str_detect(FilePath, ".jpg|.JPG|.jpeg|.JPEG|.jg$")) %>% 
  tidyr::separate(FilePath,
                  into = c("Park", "Point", "file_name"),
                  sep = "/",
                  extra = "merge")
  
#---------------------------------join to image table for matches ------

# find exact matches
images_new <- images %>% 
  dplyr::left_join(image_names_jpg, by = c("Image_filename" = "file_name")) %>% 
  dplyr::mutate(match_type = dplyr::if_else(!is.na(Point), "Exact Match", "no match")) %>% 
  dplyr::select(-c(Point, Park))

# find matches where the case may be wrong but the words are correct
images_new <- images_new %>%
  dplyr::mutate(lower_Image = tolower(Image_filename) ) %>% 
  dplyr::left_join(image_names_jpg %>% 
                     dplyr::mutate(lower_filename = tolower(file_name) ),
                   by = c("lower_Image" = "lower_filename")) %>% 
  dplyr::mutate(match_type = dplyr::if_else(!is.na(Point) & match_type=="no match",
                                            "Fuzzy match - case mismatch",
                                            match_type)) %>% 
  dplyr::select(-c(Point, Park, lower_Image, file_name))

# find matches where the filename is missing the .jpg
images_new <- images_new %>%
  dplyr::mutate(add_jpg = paste0(tolower(Image_filename),".jpg")) %>% 
  dplyr::left_join(image_names_jpg %>% 
                     dplyr::mutate(lower_filename = tolower(file_name) ),
                   by = c("add_jpg" = "lower_filename")) %>% 
  dplyr::mutate(match_type = dplyr::if_else(!is.na(Point) & match_type=="no match",
                                            "Fuzzy match - missing .jpg",
                                            match_type)) %>% 
  dplyr::select(-c(Point, Park, add_jpg, file_name))

# find matches where the filename is missing the .jpeg
images_new <- images_new %>%
  dplyr::mutate(add_jpeg = paste0(tolower(Image_filename),".jpeg")) %>% 
  dplyr::left_join(image_names_jpg %>% 
                     dplyr::mutate(lower_filename = tolower(file_name) ),
                   by = c("add_jpeg" = "lower_filename")) %>% 
  dplyr::mutate(match_type = dplyr::if_else(!is.na(Point) & match_type=="no match",
                                            "Fuzzy match - missing .jpeg",
                                            match_type)) %>% 
  dplyr::select(-c(Point, Park, add_jpeg, file_name))

# write to csv
write.csv(images_new, "tbl_Images_matchSearch.csv", row.names = FALSE)


# find out how many of each class
table(images_new$match_type)
