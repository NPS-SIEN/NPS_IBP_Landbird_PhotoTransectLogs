#' @title Fetch Data
#' @description Function connects to the user specified access back end file
#'  and extracts the image data tables
#'
#' @param db_name the file name for the access database back end
#' @param year the calendar year to determin the schedule for
#'
#' @return a table of images information with site and location information added, filtered to the user defined year
#' @export
#'
#' @examples
#' @import RODBC
#' 
fetch_data <- function(db_name, year){
  
  connection <- RODBC::odbcConnectAccess2007(here::here("INPUT_DATA",db_name))
  
  # get tables
  images <-RODBC::sqlFetch(connection, "tbl_Images")
  locations <- RODBC::sqlFetch(connection, "tbl_Locations")
  sites <- RODBC::sqlFetch(connection, "tbl_Sites")
  schedule <- RODBC::sqlFetch(connection, "tbl_Schedule")
  
  RODBC::odbcCloseAll()
  
  #put in list to pass to next function
  all_tables <- list(images = images,
                     locations = locations,
                     sites = sites,
                     schedule = schedule)
                     
  
  return(all_tables)
  
}