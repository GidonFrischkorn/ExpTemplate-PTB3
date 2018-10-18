# set working directory to source file location
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Specify Folder Paths
PATH_Main <- getwd()
PATH_Data <- paste0(PATH_Main,"DataFiles",sep="/")
TaskName <- "SimonExample"
filenames <- paste0(TaskName,"_S*","_Ses*","exp.txt")

# Load pacakges used within this script
library(dplyr)

# Specify variable names and types for the data 
ColNames <- c("Subject" , "TrialNum", "Pause", "ProbeStim","LocationCon", "CueValidity",
              "Accuracy", "RT", "Resp","CorrResp")
ColClasses <-c("integer", "integer", "factor", "factor","factor", "factor",
               "integer", "numeric", "character", "character")

# Read all files with ending *exp.txt from DataFiles Folder
filelist = list.files(pattern = paste(PATH_Data,filenames,sep = "/"))

# read all data files from filelist  
datalist = lapply(filelist, function(x)read.table(x, header=F, col.names = ColNames, colClasses = ColClasses)) 

#write all data files into one data frame
RawData = do.call("rbind", datalist) 

write.csv(RawData,paste0(TaskName,"_RawData.csv"),row.names = F)

# CleanUp the workspace
rm(filelist,datalist, ColNames, ColClasses)