# benutzte packages:
library(readr)
library(magrittr)
library(dplyr)
library(car)
library(lubridate)
library(ggplot2)
library(tidyr)
library(broom)
library(RColorBrewer)
library(ggthemes)
library(viridis)

# einlesen, dabei class overriden:
# stellt sich raus: base-r macht das besser
# sugr <- read_csv("./export3.csv",
#                    col_types = cols(Zeit = col_character()), na = c("", "NA"), n_max = 174)

sugr <- read.csv("./data/export3.csv", encoding = "UTF-8", dec = ",", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
# sugr <- sugr[c(1:174), ]

# Fehler ablegen:
# Zeit <- problems(sugr)

# Redundant, aber rgendwie ganz interessant:
#
# zeit <- zeit %>% 
#   mutate(date_time = format(parse_date_time(actual,"H!M!S!"), "%H:%M:%S"))


# unnütze Spalten loswerden, Rest umbenennen und Klassen geradebiegen:
sugr <- sugr %>% 
  select(-Bolusinjektionseinheiten..Pen., -Basalinjektionseinheiten, -Mahlzeitbeschreibung,
         -Aktivitätsintensität..1..Bequem..2..Normal..3..Anstrengend., -Schritte, -Notiz, -Ort, 
         -Blutdruck, -Körpergewicht..kg., -Ketone, -Medikamente, -Aktivitätsbeschreibung,
         -Aktivitätsdauer..Minuten., -Temp..Basalprozent, -Temp..Basaldauer..Minuten.)

colnames(sugr) <- c("Date", "Time", "Tags", "Glucoselevel", "Bolus_sum", "Bolus_BE", 
                    "Bolus_correction", "BE", "HbA1c", "Ingredients")

sugr <- sugr %>% 
  mutate(Tags         = recode(Tags, "'' = NA"),
         Ingredients  = recode(Ingredients, "'' = NA"),
         Date         = as.Date(Date, "%d.%m.%Y"),
         Time         = ymd_hms(paste(Date, Time)),
         wday         = wday(Day, T, F),
         Month        = month(Day, T, T),
         hour         = hour(Time))


# Basalraten Dataframe bauen:
basalrate <- data.frame(Zeitraum = factor(c(1:24), 
                                          labels = c("bis 1", "bis 2", "bis 3", "bis 4", "bis 5", "bis 6", 
                                                     "bis 7", "bis 8", "bis 9", "bis 10", "bis 11", "bis 12", 
                                                     "bis 13", "bis 14", "bis 15", "bis 16", "bis 17", "bis 18", 
                                                     "bis 19", "bis 20", "bis 21", "bis 22", "bis 23", "bis 24"), 
                                          ordered = T),
                        Rate_1   = c(0.3, 0.45, 0.55, 0.6, 0.6, 0.7, 0.7, 0.75, 0.85, 0.77, 0.88, 0.55,
                                     0.44, 0.45, 0.4, 0.45, 0.4, 0.4, 0.4, 0.4, 0.4, 0.3, 0.3, 0.3),
                        Rate_2   = c(0.33, 0.36, 0.6, 0.72, 0.75, 0.77, 0.75, 0.7, 0.7, 0.72, 0.58, 0.53,
                                     0.48, 0.48, 0.44, 0.44, 0.44, 0.33, 0.28, 0.27, 0.28, 0.27, 0.28, 0.28))



