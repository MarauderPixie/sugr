outliers <- sugr %>% 
  filter(!is.na(Sensorglucose), Sensorglucose > 350) %>% 
  summarize(n = n()) %>% 
  .$n


ggplot(sugr[!is.na(sugr$Sensorglucose), ], 
       aes(x = Datum, y = Sensorglucose)) + 
  geom_hline(yintercept = c(75, 175), color = "red", size = .5, linetype = "dashed") +
  geom_jitter(width = .2, size = .5, alpha = .7, color = "#9C3848",
              stroke = .8, fill = "white", shape = 21) +
  geom_smooth(method = "loess", color = "#1E3888", fill = "#1E3888", alpha = 0.3) +
  scale_x_date(date_breaks = "1 week", date_minor_breaks = "1 day",
               date_labels = "%b '%d")



sugr %>% 
  filter(Sensorglucose < 350, !is.na(Sensorglucose)) %>% 
  ggplot(aes(x = Zeit, y = Sensorglucose)) + 
  annotate("rect", fill = "black", alpha = .1,
           xmin = 1, xmax = 25200, ymin = 0, ymax = Inf) +
  geom_hline(yintercept = c(75, 175), color = "red", size = .5, linetype = "dashed") +
  geom_point(size = .3, alpha = .7, color = "#9C3848",
             stroke = .8, fill = "white", shape = 21) +
  geom_smooth(method = "loess", color = "#1E3888", fill = "#1E3888", alpha = 0.3) +
  scale_x_continuous(labels = paste0(seq(0, 24, 4), ":00 h"),
                     breaks = seq(0, 86400, 14400), 
                     minor_breaks = seq(0, 86400, 7200)) +
  labs(title = "Average daily glucose development", x = "Time", y = "glucose level (mg/dl)")

sugr %>% 
  filter(Sensorglucose < 350, !is.na(Sensorglucose)) %>% 
ggplot(aes(x = Wochentag, y = Sensorglucose, color = Wochentag, fill = Wochentag)) +
  geom_hline(yintercept = c(75, 175), color = "red", size = .5, linetype = "dashed") +
  geom_jitter(width = .3, alpha = .5, size = .5, stroke = 1, fill = "white", shape = 21) +
  geom_boxplot(alpha = .1) +
  scale_fill_viridis(discrete = T, option = "C") +
  scale_color_viridis(discrete = T, option = "C") +
  labs(title = "Overview of glucose ranges by day¹", y = "glucose level (mg/dl)",
       subtitle = "red dashes show target range", x = NULL,
       caption = paste("¹", outliers, "measurements above 350 mg/dl taken out")) +
  theme(legend.position = "none")
