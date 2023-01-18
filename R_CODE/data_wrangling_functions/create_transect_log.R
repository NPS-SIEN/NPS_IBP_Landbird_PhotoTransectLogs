#' @title Create Transect Log
#' @description Main function that creates the transect log image pdf files for each park, based upon the parameters set by the user
#'
#' @param db_name 
#' @param year 
#' @param panel_list
#' @param server_filepath 
#'
#' @return A pdf of transect images for each park. Each transect is a separate heading so it creates bookmarks in the pdf. Each point in the database has its image printed along with the file name and image description. If an image file from the database is not matched to an image location, a warning will be printed instead of the image.
#' @examples
#' 
#' @importFrom magrittr "%>%
#' @import dplyr
#' @import stringr
#' @import rmarkdown
#' 
create_transect_log<- function(db_name, year, panel_list, server_filepath){
  
  print("Fetching data..")
  all_tables <- fetch_data(db_name, year)
  
  print("Merging data..")
  image_table <- merge_data(all_tables)
  
  print("Creating filenames..")
  image_table <- create_filepaths(image_table, server_filepath)
  
  # create a pdf for each park
  for(park in unique(image_table$Park_code)){
    print(paste("creating",park, "pdf"))
    
    # create filtered table, add a image year field to sort images by year taken
    filtered_image_table <- image_table %>% 
      dplyr::filter(Park_code == park & IsActive ==1) %>% 
      dplyr::filter(Panel_name %in% panel_list | is.na(Panel_name)) %>% 
      dplyr::select(Park_code, Site_code,
                    Panel_name, Location_code, 
                    Image_filename, Image_desc,
                    full_path) %>% 
      dplyr::mutate(image_year = as.numeric(stringr::str_sub(Image_filename,1,4)),
                    transect_legs = dplyr::case_when(
                    stringr::str_starts(Location_code, "N|S|E|W") ~ stringr::str_sub(Location_code, 1,2),
                    stringr::str_starts(Location_code, "T") ~ "_TO",
                    TRUE ~ "Points")) %>%
      dplyr::arrange(Site_code,transect_legs,Location_code,image_year)
    
    # knit the pdf using Transect_log_pdf.Rmd
    rmarkdown::render(here::here("R_CODE","Transect_log_pdf.Rmd"),
                      output_file = paste0(park,"_Transect_Log_", year, ".pdf"), 
                      output_dir = here::here("OUTPUT"), 
                      params = list(park = park,
                                    year = year,
                                    filtered_image_table = filtered_image_table))
  }
}
