# Arbeitsverzeichnis setzen
setwd("C:\\Users\\Lukas\\Dropbox\\Studium\\TU Berlin\\Masterarbeit\\Analysis\\intro_questions_data")

# Daten einlesen
data <- read.csv("./intro_data.csv", sep=";")


names(data)[names(data) == "Wie.häufig.überqueren.Sie.die.Straße.als.Fußgänger."] <- "ped_freq"

t.test(data$ped_freq, mu=4, alternative = "greater")
  