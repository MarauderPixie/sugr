## unleash the toolses!
library(readr)
library(lubridate)
library(dplyr)
library(tidyr)
library(sjmisc)


## read & trim data
sugr <- read_csv(
  "~/Dokumente/tadaa-data/sugr/data/CareLink-Export-dec2016.csv", 
  col_types = cols(`Art d. tempor. Basalrate` = col_skip(), 
                   `Bolusdauer (hh:mm:ss)`    = col_time(format = "%H:%M:%S"), 
                    Datum                     = col_date(format = "%d.%m.%y"), 
                    Füllart                   = col_skip(), 
                    `Neue Gerätezeit`         = col_skip(), 
                    Rücklauf                  = col_skip(), 
                    Unterbrechen              = col_skip(), 
                    Zeit                      = col_time(format = "%H:%M:%S"), 
                    Zeitstempel               = col_datetime(format = "%d.%m.%y %H:%M:%S"),
                    `ID des verb. BZ-Messgeräts`  = col_skip(), 
                    `Dauer Temp Basal (hh:mm:ss)` = col_time(format = "%H:%M:%S")), 
  skip = 10)[1:22] 


## extract labels for later use
labels <- names(sugr)


## change names to something useful
names(sugr) <- recode(names(sugr), 
  `BZ-Messwert (mg/dl)`                         = "BZ_Wert",
  `Tempor. Basalrate (IE/h)`                    = "Temp_Basal_IE",
  `Dauer Temp Basal (hh:mm:ss)`                 = "Temp_Basal_Dauer",
  `Gewähltes Bolusvolumen (IE)`                 = "Bolus_gewaehlt",
  `Abgegebene Bolusmenge (IE)`                  = "Bolus_abgegeben",
  `Bolusdauer (hh:mm:ss)`                       = "Bolusdauer",
  `Abgegebenes Füllvolumen (IE)`                = "Abgegebene_Fuellung",
  `BolusExpert-Schätzung (IE)`                  = "BE_Schaetzung",
  `BolusExpert: Hoher BZ-Grenzwert (mg/dl)`     = "BE_Grenzwert_hi",
  `BolusExpert: Niedriger BZ-Grenzwert (mg/dl)` = "BE_Grenzwert_lo",
  `BolusExpert: KH-Faktor (Gramm)`              = "BE_KH_Faktor_gramm",
  `BolusExpert: Korrekturfaktor (mg/dl)`        = "BE_Korrekturfaktor",
  `BolusExpert: KH-Eingabe (Gramm)`             = "BE_KH",
  `BolusExpert: BZ-Eingabe (mg/dl)`             = "BE_BZ",
  `BolusExpert: Geschätzte Korrektur (IE)`      = "BE_Korrektur",
  `BolusExpert: geschätzte Nahrung (IE)`        = "BE_Nahrung",
  `BolusExpert: Aktives Insulin (IE)`           = "BE_aktives_Insulin"
  )

## well, set labels
sugr <- set_label(sugr, labels)
rm(labels)

