# set working directory and clean environment
setwd("C:/Users/Lukas/Dropbox/Studium/TU Berlin/Masterarbeit/Analysis/")
rm(list = ls())

# install (if necessary) and load psych package
if(!require(psych, quietly = TRUE)){
  install.packages("psych")
  require(psych)
}

# read in data
dataset <- read.csv("intermediate_data/intermediate_trust.csv")
questions <- c("increaseSafety","trust","trustInfo","reliable","consistent","doBest")
names(dataset) <- c(names(dataset)[1:4], questions)

# check difference between sessions numerically
aggregate(dataset[questions],by=list(dataset$Session), mean)

# internal consistency high for both session
psych::alpha(dataset[dataset$Session==1,questions])
psych::alpha(dataset[dataset$Session==2,questions])

# variance is homogenous for every scale
apply(dataset[questions], 2, function(x) aggregate(x~Session, data=dataset,sd))
apply(dataset[questions], 2, function(x) fligner.test(x~Session, data=dataset))
apply(dataset[questions], 2, function(x) bartlett.test(x~Session, data=dataset))
# compare items between sessions -> only consistency drops sig p < .05
apply(dataset[questions], 2, function(x) t.test(x~Session, data=dataset))


