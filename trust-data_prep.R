# set working directory and clean environment
setwd("C:/Users/Lukas/Dropbox/Studium/TU Berlin/Masterarbeit/Analysis/")
rm(list = ls())

# read in data
dataset <- read.csv("intermediate_data/intermediate_trust.csv")
questions <- c("increaseSafety","trust","trustInfo","reliable","consistent","doBest")
names(dataset) <- c(names(dataset)[1:4], questions)

# new column with trials corresponding to trial number in experiment data (0 based!)
dataset$expTrial <- dataset$Trial + ifelse(dataset$Session ==1, 16 - 1, 48 - 1)

# read in experiment data
exp_data <- read.csv("experiment_data/exp-data_ready.csv", header = T)

# vector of columns we need
conditions <- c("VP","trial","stopCondition","delayCondition","signalCondition","correctDecision")
cond_only <- exp_data[,conditions]
wout_timestamp <- subset(dataset, select = -c(Timestamp))
merged_data <- merge(cond_only, wout_timestamp, by.x = c("VP","trial"), by.y = c("VP.Nummer","expTrial"))

# save file
write.csv(merged_data, "intermediate_data/trust-data_ready.csv")

