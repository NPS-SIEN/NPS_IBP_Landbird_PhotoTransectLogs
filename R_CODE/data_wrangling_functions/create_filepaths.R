#' @title Create Filepaths
#' @description Function creates a new column in images table for the generated full image filepaths
#'
#' @param image_table a merged table of image information
#' @param server_filepath the user specified main pathway to the images folder
#'
#' @return a modified image table with generated filepaths to each image 
#'
#' @examples
create_filepaths<- function(image_table, server_filepath ){
  
  image_table = image_table
  server_filepath = server_filepath
  
  # add a new column to hold created filepaths
  image_table$full_path <- paste(server_filepath,
                                 image_table$Park_code,
                                 image_table$Site_code,
                                 image_table$Image_filename,
                                 sep = "\\")

  return(image_table) 
}