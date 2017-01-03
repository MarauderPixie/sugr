## unleash the toolses!
library(readr)
library(stringr)
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
                   `Dauer Temp Basal (hh:mm:ss)` = col_time(format = "%H:%M:%S"),
                   `BolusExpert: Hoher BZ-Grenzwert (mg/dl)`     = col_skip(), 
                   `BolusExpert: Niedriger BZ-Grenzwert (mg/dl)` = col_skip(), 
                   `BolusExpert: Korrekturfaktor (mg/dl)`        = col_skip()), 
  skip = 10)[1:19] 


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
  `BolusExpert: KH-Faktor (Gramm)`              = "BE_KH_Faktor_gramm",
  `BolusExpert: KH-Eingabe (Gramm)`             = "BE_KH",
  `BolusExpert: BZ-Eingabe (mg/dl)`             = "BE_BZ",
  `BolusExpert: Geschätzte Korrektur (IE)`      = "BE_Korrektur",
  `BolusExpert: geschätzte Nahrung (IE)`        = "BE_Nahrung",
  `BolusExpert: Aktives Insulin (IE)`           = "BE_aktives_Insulin"
  )


## replace commas with points & convert to numeric
sugr <- sugr %>% 
  mutate(Bolus_gewaehlt  = as.numeric(str_replace(Bolus_gewaehlt, ",", ".")),
         Bolus_abgegeben = as.numeric(str_replace(Bolus_abgegeben, ",", ".")),
         BE_Schaetzung   = as.numeric(str_replace(BE_Schaetzung, ",", ".")),
         BE_Korrektur    = as.numeric(str_replace(BE_Korrektur, ",", ".")),
         BE_Nahrung      = as.numeric(str_replace(BE_Nahrung, ",", ".")),
         BE_aktives_Insulin = as.numeric(str_replace(BE_aktives_Insulin, ",", ".")))


## add some info
sugr <- sugr %>% 
  mutate(Monat      = month(Zeitstempel, label = T, abbr = F),
         Wochentag  = wday(Datum, label = T, abbr = F),
         BZ_Bereich = cut(BZ_Wert, breaks = c(-Inf, 80, 160, Inf), ordered_result = T,
                          labels = c("zu niedrig", "in Ordnung", "zu hoch")))


## well, set labels
sugr <- set_label(sugr, c(labels, "Monat", "Wochentag", "Blutzuckerbereich"))
rm(labels)


## create Basalraten-Dataframe
base <- data.frame(
  Uhrzeit = parse_time(
    format(seq(ISOdatetime(2017, 1, 2, 1, 0, 0), 
               ISOdatetime(2017, 1, 3, 00, 00, 00), 
               by = 60*60), "%H:%M"),
    format = "%H:%M"),
  Rate_1  = c(0.35, 0.35, 0.6, 0.725, 0.75, 0.75, 0.675, 0.6, 0.7,
              0.75, 0.7, 0.7, 0.575, 0.6, 0.55, 0.375, 0.35, rep(0.3, 7))
)


## filter for BolusExpert data & "fix" decimals
bexpert <- filter(sugr, !is.na(BE_KH))

bexpert$BE_KH[nchar(bexpert$BE_KH) > 2] <- 
  bexpert$BE_KH[nchar(bexpert$BE_KH) > 2] / 10

bexpert$BE_KH_Faktor_gramm[nchar(bexpert$BE_KH_Faktor_gramm) > 2] <- 
  bexpert$BE_KH_Faktor_gramm[nchar(bexpert$BE_KH_Faktor_gramm) > 2] / 10


## save to file
saveRDS(sugr, "./data/sugr.rds")
saveRDS(base, "./data/base.rds")
saveRDS(bexpert, "./data/bexpert.rds")