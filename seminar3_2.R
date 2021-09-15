#### SEMINAR 3 ####

## Plan for seminaret ##
# 1. Laste inn pakker og forberede data (repetisjon)
# 2. Lineær regresjon (OLS)
# 3. Hvordan plotter vi resultater fra OLS?
# 4. Hvordan slår vi sammen flere datasett?


## 1. Laste inn pakker og forberede data (repetisjon) ##
# Henter pakker 

library(haven)
library(tidyverse)

# Laste inn .RData
load("aid.RData")
aid <- read_dta("aid.dta")

# Omkoder region-variabelen 

aid <- aid %>% 
        mutate(region = ifelse(fast_growing_east_asia == 1, "East Asia", 
                               ifelse(sub_saharan_africa == 1, "Sub-Saharan Africa", 
                                      ifelse(central_america == 1, "Central America", "Other"))))


# 2. Lineær regresjon (OLS)

# Syntaks 


# Bivariat regresjon
mod1 <- lm(gdp_growth ~ aid, aid)
summary(mod1)
class(mod1)
str(mod1)


# Multivariat regresjon 
mod2 <- lm(gdp_growth ~ aid + policy + region, aid)
summary(mod2)

# Samspill 
mod3 <- lm(gdp_growth ~ aid * policy + region, aid)
summary(mod3)


# Andregradsledd og andre omkodinger 
mod4 <- lm(gdp_growth ~ log(gdp_pr_capita) + institutional_quality + I(institutional_quality^2) +
             region + aid * policy + as.factor(period), aid)
summary(mod4)

# Fine tabeller med stargazer()
install.packages("stargazer")
library(stargazer)

# Output i console
stargazer(mod2, mod3, 
          type = "text")

# Lagre tabell 
stargazer(mod2, mod3, 
          type = "html", 
          out = "tabell.htm")

# Output i latex
stargazer(mod2, mod3, 
          type = "latex")

# 3. Hvordan plotter vi resultater fra OLS?

# Kjører en redusert modell
mod5 <- lm(gdp_growth ~ aid + policy, aid,
           na.action = "na.exclude")

# Lager datasett hvor kun den uavhengige variabelen, som vi vil plotte effekten, varierer
snitt_data <- data.frame(policy = c(seq(min(aid$policy, na.rm = TRUE),
                                       max(aid$policy, na.rm = TRUE), by = 0.5)),
                        aid = mean(aid$aid, na.rm = TRUE))

# Bruker predict()

predikert <- predict(mod5, newdata = snitt_data, se = TRUE, interval = "confidence")

rm(snitt_data)

# Legger predikerte verdier inn i snitt_data

snitt_data <- cbind(snitt_data, predikert)

# Lager et plott

ggplot(snitt_data, aes(policy, fit.fit)) +
  geom_line() + 
  scale_y_continuous(breaks = seq(-12, 12, 2)) +
  geom_ribbon(aes(ymin = fit.lwr, ymax = fit.upr, color = NULL), alpha = .2) +
  labs(title = "Regresjonslinje", x = "Policy index", y = "Forventet GDP vekst")

# Plotter resultater for en modell med samspill 

# Redusert med samspill
mod6 <- lm(gdp_growth ~ aid * policy, aid, 
           na.action = "na.exclude")

# Lager plott-data

snitt_data_sam <- data.frame(policy = c(rep(-1, 9), rep(0, 9), rep(1, 9)),
                             aid = rep(0:8, 3))

# Predikerte verdier

predikert_sam <- predict(mod6, newdata = snitt_data_sam, se = TRUE, interval = "confidence")

# Legger predikerte verdier inn i snitt_data_sam

snitt_data_sam <- cbind(snitt_data_sam, predikert_sam)

# Plotter

ggplot(snitt_data_sam, aes(aid, fit.fit,
                           group = factor(policy),
                           col = factor(policy), 
                           fill = factor(policy))) + 
  geom_line() + 
  scale_y_continuous(breaks = seq(-12, 12, 2)) + 
  geom_ribbon(aes(ymin = fit.lwr, ymax = fit.upr, col = NULL), alpha = .2) + 
  labs(x = "Bistandsnivå", y = "Forventet GDP vekst", color = "Policy", fill = "Policy")

# Fjerner objekt fra enviroment med rm()

rm(mod1)

# 4. Hvordan slår vi sammen flere datasett?

aid

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

# Oppretter periode-variabel i equality-datasettet

table(aid$periodstart, aid$period)
table(aid$periodend, aid$period)

periodcutpoints <- unique(c(aid$periodstart))
equality$period <- cut(equality$year, periodcutpoints)
table(equality$year, equality$period)

# Endrer for at det skal bli riktig
periodcutpoints <- periodcutpoints - 1
periodcutpoints <- c(1965, periodcutpoints, 1993, 1997)
equality$period <- cut(equality$year, periodcutpoints)
table(equality$year, equality$period)

equality$period <- as.numeric(as.factor(equality$period))
table(equality$year, equality$period)

# Endrer på datastrukturen til equality for at det skal matche aid 

agg_equality <- equality %>% 
  group_by(country_text_id, period) %>%
  summarise(avg_eq = mean(v2pepwrsoc, na.rm = TRUE)) %>%
  mutate(period_num = as.numeric(period))

table(agg_equality$period, agg_equality$period_num)

# Kombinerer equality_agg og aid med left_join()

aid2 <- left_join(aid, agg_equality, 
                  by = c("country" = "country_text_id", "period" = "period_num"))

# Sjekker missing
table(is.na(aid2$avg_eq))

# Sjekker land med base r
table(aid2$country[which(is.na(aid2$avg_eq))])

# Sjekker land med dplyr
aid2 %>% 
  filter(is.na(avg_eq)) %>%
  select(country)

# Henter ut informasjon om variabelen aid2$avg_eq i det nye datasettet

summary(aid2$avg_eq)
