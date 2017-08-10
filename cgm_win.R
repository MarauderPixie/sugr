## unleash the toolses!
library(tidyverse)
library(lubridate)
library(stringr)
library(sjmisc)


## read it!
neu <- read_csv(
  "data/neu.csv", col_types = cols(`BZ-Wert für Sensorkalibrierung (mg/dl)` = col_integer(), 
                                   `BolusExpert-Schätzung (IE)` = col_double(), 
                                   `BolusExpert: Aktives Insulin (IE)` = col_integer(), 
                                   `BolusExpert: Geschätzte Korrektur (IE)` = col_integer(), 
                                   `BolusExpert: geschätzte Nahrung (IE)` = col_integer(), 
                                   Datum = col_date(format = "%d.%m.%y"), 
                                   `Sensorglukose (mg/dl)` = col_integer(), 
                                   `Tages-Gesamtinsulin (IE)` = col_integer(), 
                                   Zeit = col_time(format = "%H:%M:%S"), 
                                   Zeitstempel = col_datetime(format = "%d.%m.%y %H:%M:%S")), 
                skip = 11)[, c(1:4, 6, 13, 22:28, 30, 31, 33)]


## extract labels for later use
labels <- names(neu)


## change names to something useful
names(neu) <- recode(names(neu),
                     `BZ-Messwert (mg/dl)`                         = "BZ_Wert",
                     `Tempor. Basalrate (IE/h)`                    = "Temp_Basal_IE",
                     `Dauer Temp Basal (hh:mm:ss)`                 = "Temp_Basal_Dauer",
                     `Gewähltes Bolusvolumen (IE)`                 = "Bolus_gewaehlt",
                     `Abgegebene Bolusmenge (IE)`                  = "Bolus_abgegeben",
                     `Bolusdauer (hh:mm:ss)`                       = "Bolusdauer",
                     `Abgegebenes Füllvolumen (IE)`                = "Abgegebene_Fuellung",
                     `BolusExpert-Schätzung (IE)`                  = "Bexpert_Schaetzung",
                     `BolusExpert: KH-Faktor (Gramm)`              = "Bexpert_KH_Faktor_gramm",
                     `BolusExpert: KH-Eingabe (Gramm)`             = "Bexpert_KH",
                     `BolusExpert: BZ-Eingabe (mg/dl)`             = "Bexpert_BZ",
                     `BolusExpert: Geschätzte Korrektur (IE)`      = "Bexpert_Korrektur",
                     `BolusExpert: geschätzte Nahrung (IE)`        = "Bexpert_Nahrung",
                     `BolusExpert: Aktives Insulin (IE)`           = "Bexpert_aktives_Insulin",
                     `BZ-Wert für Sensorkalibrierung (mg/dl)`      = "BZ_Kalibrierung",
                     `Sensorglukose (mg/dl)`                       = "Sensorglucose",
                     `Tages-Gesamtinsulin (IE)`                    = "Tagesmenge_IE"
)


## replace commas with points & convert to numeric
neu <- neu %>%
  mutate(Bolus_abgegeben = as.numeric(str_replace(Bolus_abgegeben, ",", ".")))


## add some info, convert KH/IE to IE/BE (and fix decimals in the process)
neu <- neu %>%
  mutate(Jahr       = year(Zeitstempel),
         Monat      = month(Zeitstempel, label = T, abbr = F),
         Wochentag  = wday(Datum, label = T, abbr = F),
         BZ_Bereich = cut(BZ_Wert, breaks = c(-Inf, 80, 160, Inf), ordered_result = T,
                          labels = c("zu niedrig", "in Ordnung", "zu hoch")),
         Bexpert_KH      = round(ifelse(nchar(Bexpert_KH) > 2,
                                        Bexpert_KH / 150,
                                        Bexpert_KH / 15), 2),
         Bexpert_KH_Faktor_gramm = round(ifelse(nchar(Bexpert_KH_Faktor_gramm) > 2,
                                                Bexpert_KH_Faktor_gramm / 150,
                                                Bexpert_KH_Faktor_gramm / 15), 2)
  )
