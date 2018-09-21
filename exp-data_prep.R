# set working directory and clean environment
setwd("C:/Users/Lukas/Dropbox/Studium/TU Berlin/Masterarbeit/Analysis/")
rm(list = ls())

# read in data sets
datafiles = list.files(path="./experiment_data", pattern="\\d+.csv", full.names = TRUE)
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
  
  # timeToDecision = decisionTime - trialStartTime
  x$timeToDecision <- x$decisionTime - x$trialStartTime
  
  # reactionTime = decisionTime - signalOnsetTime - avgRT (for each hand)
  x$avgRT <- x$avgRTLeft
  x$avgRT[x$reactionHand == 1] <- x$avgRTRight[x$reactionHand == 1]
  x$reactionTime <- x$decisionTime - x$signalOnsetTime - x$avgRT
  
  # reactionAfterSignal
  x$reactionAfterSignal <- as.integer(x$reactionTime > 0)
  
  # leftStartArea
  x$leftStartArea <- as.integer(x$leftStartAreaTime > 0)
  
  
  # code session for time analysis
  x$session <- floor(x$trial / 16)
  
  
  # make conditions factors
  x$reactionHand <- factor(x$reactionHand, levels=c(0,1), labels = c("left(wait)", "right(cross)"))
  x$stopCondition <- factor(x$stopCondition, levels=c(0,1), labels = c("no brake", "brake"))
  x$signalCondition <- factor(x$signalCondition, levels=c(0,1,2,3), labels = c("no signal", "eyes", "ampelmann", "eyes + ampelmann"))
  x$delayCondition <- factor(x$delayCondition, levels=c(0,1), labels = c("on brake", "before brake"))
  x$correctDecision <- factor(x$correctDecision, levels=c(0,1), labels = c("no", "yes"))
  x$reactionAfterSignal <- factor(x$reactionAfterSignal, levels=c(0,1), labels = c("before signal", "after signal"))
  x$leftStartArea <- factor(x$leftStartArea, levels=c(0,1), labels = c("stayed", "walked"))
  x$session <- factor(x$session, levels=c(0,1,2,3), labels = c("1", "2","3","4"))
  
  # make ratings numeric
  x$safetyRating <- as.numeric(x$safetyRating)
  x$securityRating <- as.numeric(x$securityRating)
  x$confidenceRating <- as.numeric(x$confidenceRating)
  
  
  # return the modified dataframe
  return(x)
})

# merge cleaned list of datasets into one dataframe
dataframe <- do.call("rbind", datasets)


# load trust dataset
trustdata <- read.csv("intermediate_data/intermediate_trust.csv")

# rename columns
newNames <- c("timestamp", "VP", "session", "trial","increaseSafety","trust","trustInfo","reliable","consistent","doBest")
names(trustdata) <- newNames

# shift trial numbers to correspond to experiment data
trustdata$trial <- trustdata$trial + ifelse(trustdata$session ==1, 16 - 1, 48 - 1)

# remove timestamp and session variable
trustdata <- subset(trustdata, select = -c(timestamp, session))


# pad dataset with NaN vectors for trials in which trust was not asked
nullData = data.frame(VP=rep(NaN,992), 
                      trial=rep(NaN,992),
                      increaseSafety=rep(NaN,992),
                      trust=rep(NaN,992),
                      trustInfo=rep(NaN,992),
                      reliable=rep(NaN,992),
                      consistent=rep(NaN,992),
                      doBest=rep(NaN,992))
nullData$trial <- rep(c(0:15, 32:47),31)
nullData$VP <- rep(1:31,each=32)
trustdata <- rbind(trustdata, nullData)

# merge trust data into experiment data
dataframe <- merge(dataframe, trustdata, by = c("VP","trial"))

# save file as RDS for analysis in R and CSV for everything else
saveRDS(dataframe, "experiment_data/exp-data_ready.Rds")
write.csv(dataframe, "experiment_data/exp-data_ready.csv")
