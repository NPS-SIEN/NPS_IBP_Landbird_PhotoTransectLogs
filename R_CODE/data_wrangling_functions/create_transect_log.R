#' Title
#'
#' @param db_name 
#' @param year 
#' @param panel_list
#' @param server_filepath 
#'
#' @return
#' @export
#'
#' @examples
create_transect_log<- function(db_name, year, panel_list, server_filepath){
  
  print("fetching data")
  all_tables <- fetch_data(db_name, year)
  
  print("merging data")
  image_table <- merge_data(all_tables)
  
  print("creating filenames")
  image_table <- create_filepaths(image_table, server_filepath)
  
  # create a pdf for each park
  for(park in unique(image_table$Park_code)){
    print(paste("creating",park, "pdf"))
    
    # create filtered table
    filtered_image_table <- image_table %>% 
      dplyr::filter(Park_code == park & IsActive ==1) %>% 
      dplyr::filter(Panel_name %in% panel_list | is.na(Panel_name)) %>% 
      dplyr::select(Park_code, Site_code,
                    Panel_name, Location_code, 
                    Image_filename, Image_desc,
                    full_path) %>% 
      dplyr:: arrange(Location_code)
    
    rmarkdown::render(here::here("R_CODE","Transect_log_pdf.Rmd"),
                      output_file = paste0(park,"_Transect_Log_", year, ".pdf"), 
                      output_dir = here::here("OUTPUT"), 
                      params = list(park = park,
                                    year = year,
                                    filtered_image_table = filtered_image_table))
  }
  

  
}
