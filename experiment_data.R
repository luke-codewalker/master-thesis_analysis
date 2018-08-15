# set working directory
setwd("C:/Users/Lukas/Dropbox/Studium/TU Berlin/Masterarbeit/Analysis/")

# read in data sets
datafiles = list.files(path="./experiment_data", pattern=".csv", full.names = TRUE)
datasets = lapply(datafiles, function(x) read.csv(x, sep=";"))
names(datasets) = gsub("./experiment_data/experiment-data_(VP\\d+).csv","\\1",datafiles)

# check number formats and convert to int in miliseconds if neccessary
datasets = lapply(datasets, function(x) lapply(x, function(y) if(typeof(y)=="double") y*1000 else y))
