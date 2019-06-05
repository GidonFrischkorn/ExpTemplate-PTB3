# set working directory to source file location
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Specify Folder Paths and the extension for the files to load
PATH_Main <- getwd()
PATH_Data <- paste(PATH_Main,"DataFiles",sep="/")
filenames_pattern <-"*exp.txt"

# Load pacakges used within this script
library(dplyr)

# Specify variable names and types for the data 
ColNames <- c("Subject" , "TrialNum", "Pause", "ProbeStim","LocationCon", "CueValidity",
              "Accuracy", "RT", "Resp","CorrResp")
ColClasses <-c("integer", "integer", "factor", "factor","factor", "factor",
               "integer", "numeric", "character", "character")

# Read all files with ending *exp.txt from DataFiles Folder
filelist = list.files(pattern = filenames_pattern, path = PATH_Data)

# paste the full path 
Full_filelist  = paste(PATH_Data,filelist,sep = "/")

# read all data files from filelist  
datalist = lapply(filelist, function(x) read.table(x, header=F, col.names = ColNames, colClasses = ColClasses)) 

#write all data files into one data frame
RawData = do.call("rbind", datalist) 

# export the RawData for all subjects into one single csv-File
write.csv(RawData,paste0(PATH_Data,"/",TaskName,"_RawData.csv"),row.names = F)

# CleanUp the workspace
rm(filelist,datalist, ColNames, ColClasses)

#### End of Code ####
# This R Script was programmed by Gidon T. Frischkorn, as part of a
# template for MATLAB experiments. If you have any questions please contact
# me via mail: gidon.frischkorn@psychologie.uzh.ch
