#### SEMINAR 3 ####

## Plan for seminaret ##
# 1. Laste inn pakker og forberede data (repetisjon)
# 2. Lineær regresjon (OLS)
# 3. Hvordan plotter vi resultater fra OLS?
# 4. Hvordan slår vi sammen flere datasett?


## 1. Laste inn pakker og forberede data (repetisjon) ##

# Henter pakker 
library(tidyverse)
library(haven)

# Forbereder data
load("aid.RData")
rm(aid)

aid <- read_dta("aid.dta")

# Omkoder regionvariabelen
aid <- aid %>%
  mutate(region = ifelse(fast_growing_east_asia == 1, "East Asia", 
                         ifelse(sub_saharan_africa == 1, "Sub-Saharan Africa", 
                                ifelse(central_america == 1, "Central America", "Other"))))


# 2. Lineær regresjon (OLS)

# Syntaks 
lm(avhengigvariabel ~ uavhengigvariabel, data = datasett)

# Bivariat regresjon
m1 <- lm(gdp_growth ~ aid, aid)
summary(m1)
str(m1)


# Multivariat regresjon 

m2 <- lm(gdp_growth ~ aid + policy + region, aid) 
summary(m2)

# Samspill 
m3<- lm(gdp_growth ~ aid *policy + region, aid) 
summary(m3)

# Andregradsledd og andre omkodinger 
m4 <- lm(gdp_growth ~ log(gdp_pr_capita) + institutional_quality + I(institutional_quality^2) +
           region + aid*policy + as.factor(period), aid) 
summary(m4)

# Endre referansekategori

class(aid$region) # sjekker klassen til region og ser at det er character

aid$region <- as.factor(aid$region) # koder om til faktor for å kunne endre referansekategorien

levels(aid$region) # ser at Central America er første kategori
# når man endrer til faktor og ikke spesifiserer noe annet, legger R kategoriene i 
# alfabetisk rekkefølge

mref <- lm(gdp_growth ~ aid + policy + relevel(region, ref = "Other"), aid) 
# endrer referansekategorien til Other med relevel() og argumentet ref

summary(mref)

levels(aid$region)

# Fine tabeller med stargazer()
install.packages("stargazer") 
library(stargazer)

stargazer(m2, m3, 
          type = "text")

stargazer(m1, 
          type = "html", 
          out = "mintabell.htm")

stargazer(m2,
          type = "latex")

# 3. Hvordan plotter vi resultater fra OLS?

# Kjører en redusert modell
m5 <- lm(gdp_growth ~ aid + policy, aid, na.action = "na.exclude")


# Lager datasett hvor kun den uavhengige variabelen, som vi vil plotte effekten, varierer
snitt_data <- data.frame(policy = c(seq(min(aid$policy, na.rm = TRUE),
                                        max(aid$policy, na.rm = TRUE), by = 0.5)),
                         aid = mean(aid$aid, na.rm = TRUE))


# Bruker predict()
predict(m5, newdata = snitt_data, se = TRUE, interval = "confidence")

predikert <- predict(m5, newdata = snitt_data, se = TRUE, interval = "confidence")

# Legger predikerte verdier inn i snitt_data

snitt_data <- cbind(snitt_data, predikert)
snitt_data <- cbind(snitt_data, predict(m5, newdata = snitt_data, se = TRUE, interval = "confidence"))

# Lager et plott

ggplot(snitt_data, aes(policy, fit.fit)) + 
  geom_line() + # legger til regresjonslinje
  scale_y_continuous(breaks = seq(-12, 12, 2)) + # endrer på y-aksen
  geom_ribbon(aes(ymin = fit.lwr, ymax = fit.upr, color = NULL), alpha = 0.2) + # legger til konfidensintervallet
  labs(x = "Policy index", y = "Forventet GDP vekst",  # legger til tittel osv. 
       title = "Burnside & Dollar replikasjon")


# Plotter resultater for en modell med samspill 

m6 <- lm(gdp_growth ~ aid * policy, aid, na.action = "na.exclude")

# Lager plot data
snitt_data_sam <- data.frame(policy = c(rep(-1, 9), rep(0, 9), rep(1, 9)), 
                             aid = rep(0:8, 3))

# Predikere verdier
predict(m6, newdata = snitt_data_sam, se = TRUE, interval = "confidence")

#Lagrer predikert verdier i plot-datasettet

snitt_data_sam <- cbind(snitt_data_sam, predict(m6, newdata = snitt_data_sam, se = TRUE, interval = "confidence"))

# Plotter
ggplot(snitt_data_sam, aes(aid, fit.fit, 
                           group = factor(policy), 
                           color = factor(policy), 
                           fill = factor(policy))) + 
  geom_line() + 
  scale_y_continuous(breaks= seq(-12, 12, 2)) + 
  geom_ribbon(aes(ymin = fit.lwr, ymax = fit.upr, color = NULL, alpha = 0.5))

# Fjerner objekt fra enviroment med rm()
rm(snitt_data)

# 4. Hvordan slår vi sammen flere datasett?

# Laster inn datasettet equality med read_csv()

equality <- read_csv("https://raw.githubusercontent.com/liserodland/stv4020aR/master/H20-seminarer/Innf%C3%B8ringsseminarer/data/Vdem_10_redusert.csv")

# Hvilker variabler har aid og equality til felles?


# Bruker logisk test for å sjekke om aid$country og equality$country_text_id matcher
table(aid$country %in% equality$country_text_id)

# Sjekker hvilke observasjoner som ikke matcher
aid %>%
  select(country) %>%
  anti_join(equality, by = c("country" = "country_text_id")) %>%
  unique()

# Slår vi sammen uten å opprette ny variabel for period
table(aid$periodstart %in% equality$year)

# Bruker left_join()
aid2 <- aid %>%
  left_join(equality, by = c("country" = "country_text_id", "periodstart" = "year"))

# Sjekker missing 
table(is.na(aid2$v2pepwrsoc))

# Sjekker hvilke land med tidyverse
aid2 %>% 
  filter(is.na(v2pepwrsoc)) %>%
  select(country)

# Henter informasjon om ny variabel
summary(aid2$v2pepwrsoc)

# Oppretter periode-variabel i equality-datasettet
table(aid$periodstart, aid$period)
table(aid$periodend, aid$period)

periodcutpoints <- unique(c(aid$periodstart))
equality$period <- cut(equality$year, periodcutpoints)

table(equality$year, equality$period)

periodcutpoints <- periodcutpoints - 1
periodcutpoints <- c(1965, periodcutpoints, 1993, 1997)

# prøver på nytt
equality$period <- cut(equality$year, periodcutpoints)
table(equality$year, equality$period)

equality$period <- as.numeric(as.factor(equality$period))

# Endrer på datastrukturen til equality for at det skal matche aid 

agg_equality <- equality %>%
  group_by(country_text_id, period) %>%
  summarise(avg_eq = mean(v2pepwrsoc, na.rm = TRUE)) %>%
  mutate(period_num = as.numeric(period))

# Kombinerer equality_agg og aid med left_join()
aid3 <- left_join(aid, agg_equality,
                  by = c("country" = "country_text_id", "period" = "period_num"))

# Sjekker missing


# Henter ut informasjon om variabelen aid2$avg_eq i det nye datasettet
