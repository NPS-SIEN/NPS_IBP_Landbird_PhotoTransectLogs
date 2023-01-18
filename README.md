# NPS_IBP_Landbird_PhotoTransectLogs

Contains scripts and tools needed to generate the photo transect logs for the NPS IBP Landbird monitoring projects.


This tool comprises of two parts separated for ease of use:

  - A front end script where the user updates the required variables and checks packages.
  
  - A series of functions and an R markdown script for all the data wrangling code and pdf creation in a folder called R_CODE.

To use:

  1.  Download this whole project from Github to a local machine.
  1.  Copy the current Access database back end into the INPUT_DATA folder within the main project folder. 
  1.  Open the PROJECT script (NPS_IBP_Landbird_PhotoTransectLogs.Rproj) either from an open R studio session or from windows explorer. This will launch the project files in a new R studio session and set the correct working directory and environment.
  1.  Open the front end script (Transect_Log_Front_End) from the Files pane in R studio.
  1.  Update the user variables for the:
      *  Copied Access database name,
      *  Survey Year,
      *  List of panels for the survey year,
      *  The server filepath (up to the park subfolder) that contains the transect images.
  1. Check that you have all the R packages required installed - R studio now tells you at the top if you don't and gives you an easy button to install!
  1.  Run all the code. This will load the user variables into the global environment, call and run the functions and RMD, and export out the pdf's into the OUTPUT folder.
  
  
The code is written with ease of understanding and updating in mind. Therefore it may not be the most efficient! If changes are needed due to database schema changes in the future, it should be easy to find where to make the updates in the script.
