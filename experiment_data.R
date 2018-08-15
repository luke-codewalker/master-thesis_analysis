# set working directory
setwd("C:/Users/Lukas/Dropbox/Studium/TU Berlin/Masterarbeit/Analysis/")

# read in first data set
data <- read.csv("./raw_experiment_data/experiment-data_VP4.csv", sep=";")
typeof(data$signalOnsetTime[0])
typeof(data$signalOnsetTime[20])
typeof(data$signalOnsetTime[60])
