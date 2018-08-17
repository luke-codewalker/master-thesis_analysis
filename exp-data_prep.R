# set working directory and clean environment
setwd("C:/Users/Lukas/Dropbox/Studium/TU Berlin/Masterarbeit/Analysis/")
rm(list = ls())


# read in data sets
datafiles = list.files(path="./experiment_data", pattern=".csv", full.names = TRUE)
datasets = lapply(datafiles, function(x) read.csv(x, sep=";"))
names(datasets) = gsub("./experiment_data/experiment-data_(VP\\d+).csv","\\1",datafiles)

# check number formats and convert to int in miliseconds if neccessary
datasets = lapply(datasets, function(x) {
  x <- lapply(x, function(y){
    if(typeof(y)=="double") y*1000 else y=y
  })  
  return(data.frame(x))
})

# decode condition into variables
datasets = lapply(datasets, function(x){ 
  # stopCondition: 0 = no stop, 1 = stop
  x$stopCondition <- ifelse(as.numeric(substr(as.character(x$condition),1,1))<4,0,1)
  # delayCondition: 0 = no delay (signal on braking), 1 = signal before braking
  x$delayCondition <- ifelse(substr(as.character(x$condition),2,2)=="a",0,1)
  # signalCondition: 0 = none, 1 = eyes, 2 = ampel, 3 = both
  x$signalCondition <- as.numeric(substr(as.character(x$condition),1,1))%%4
  # correctDecision: 0 = no, 1 = yes
  x$correctDecision <- ifelse(x$stopCondition == x$reactionHand,1,0)
  # reactionTime = decisionTime - trialStartTime
  x$reactionTime = x$decisionTime - x$trialStartTime
  return(x)
})

# merge cleaned list of datasets into one dataframe
dataframe <- do.call("rbind", datasets)

# save file
write.csv(dataframe, "experiment_data/exp-data_ready.csv",row.names=F)
