#' @title Merge Data
#' @description merges elements of the database tables together to give an images table with location and site information for the selected year
#'
#' @param all_tables nested list of exported tables from the access database
#'
#' @return a merged image table
#'
#' @examples
#' 
#' @importFrom magrittr "%>%
#' @import dplyr
#' 
merge_data <- function(all_tables){
  
  all_tables = all_tables
  
  # filter schedule by year
  schedule<- all_tables$schedule[all_tables$schedule$Calendar_year==year,]
  
  #Get scheduled sites for the year
  scheduled_sites <- all_tables$sites %>% 
    dplyr::select(Site_ID, Park_code, Site_code, Panel_name) %>% 
    dplyr::inner_join(schedule, by = "Site_ID") %>% 
    dplyr::select(-Schedule_notes)
  
  # get relevent location information
  scheduled_locations <- all_tables$locations %>% 
    dplyr::select(Location_ID, Site_ID, Location_code) %>% 
    dplyr::inner_join(scheduled_sites, by = "Site_ID")
  
  # join with images table and export needed fields
  image_table <- all_tables$images %>% 
    inner_join(scheduled_locations, by = "Location_ID")
  
  return(image_table)
}