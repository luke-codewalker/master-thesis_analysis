# set working directory and clean environment
setwd("C:/Users/Lukas/Dropbox/Studium/TU Berlin/Masterarbeit/Analysis/")
rm(list = ls())


# table of decision for all participants
xtabs(~reactionHand, dataframe)/nrow(dataframe) 

# cross table of decision over stop condition for all participants
xtabs(~reactionHand+stopCondition, dataframe)/nrow(dataframe)                  

# cross table of decision over stop condition and stop condition for all participants
xtabs(~reactionHand+signalCondition+stopCondition, dataframe)/nrow(dataframe)*2                  

# cross table of decision over delay condition for all participants
xtabs(~reactionHand+delayCondition, dataframe)/nrow(dataframe)                  

# cross table of correct decision over stop condition for all participants
xtabs(~correctDecision, dataframe)/nrow(dataframe)

# cross table of correct decision over stop condition for all participants
xtabs(~correctDecision+stopCondition, dataframe)/nrow(dataframe) *2

# cross table of correct decision over signal condition for all participants
xtabs(~correctDecision+signalCondition, dataframe)/nrow(dataframe) *4

# aggregate reaction time over signal conditions 
aggregate(reactionTime ~ signalCondition, dataframe, mean)

# aggregate reaction time over delay conditions (only when signal present)
aggregate(reactionTime ~ delayCondition, dataframe[dataframe$signalCondition>0,], mean)

# aggregate safety rating over signal conditions (and delay or stop condition)
aggregate(as.numeric(safetyRating) ~ signalCondition, dataframe, mean)
aggregate(as.numeric(safetyRating) ~ signalCondition + stopCondition, dataframe, mean)
aggregate(as.numeric(safetyRating) ~ signalCondition + delayCondition, dataframe, mean)

# aggregate security rating over signal conditions
aggregate(as.numeric(securityRating) ~ signalCondition, dataframe, mean)

# aggregate confidence rating over signal conditions
aggregate(as.numeric(confidenceRating) ~ signalCondition, dataframe, mean)

