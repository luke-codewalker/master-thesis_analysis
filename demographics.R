# set working directory
setwd("C:/Users/Lukas/Dropbox/Studium/TU Berlin/Masterarbeit/Analysis/")

# read in data set
data <- read.csv("./intro_questions_data/intro_data.csv", sep=";")


names(data)[names(data) == "Wie.h�ufig.�berqueren.Sie.die.Stra�e.als.Fu�g�nger."] <- "ped_freq"

t.test(data$ped_freq, mu=4, alternative = "greater")