#### SEMINAR 4 ####

## Plan for seminaret ##
# 1. Logistisk regresjon med glm()
# 2. Plotte effekter
# 3. Forventet verdi vs. faktisk verdi - residualer


## 1. Logistisk regresjon med glm() ##

# Laster inn pakker
library(tidyverse)
library(haven)

# Laster inn datasettet
aid <- read_dta("aid.dta")


# Oppretter ny dikotom variabel
aid <- aid %>%
  mutate(gdp_growth_d = ifelse(gdp_growth <= 0, 0, 1))

table(is.na(aid$gdp_growth_d), 
      is.na(aid$gdp_growth))


# Trinn 1: Kjører binomisk logistisk model med glm()

m1 <- glm(gdp_growth_d ~ aid + policy + as.factor(period), aid,
          family = "binomial", 
          na.action = "na.exclude")

summary(m1)


# Viser resultatene i en tabell med stargazer()
library(stargazer)

stargazer(m1, 
          type = "text")

# for å kopiere til dokument 
stargazer(m1, 
          type = "html", 
          out = "mintabell.htm")

# Regne om til predikert sannsynlighet

m1$coefficients

## 2. Plotte effekter ##

# Plotter effekter: logits #
# Trinn 2: Vi lager et datasett med plotdata der vi lar aid variere

plotdata <- data.frame(aid = seq(min(aid$aid, na.rm = TRUE), 
                                max(aid$aid, na.rm = TRUE), 1), 
                      policy = mean(aid$policy, na.rm = TRUE), 
                      period = "4")

table(aid$period)

# Trinn 3: Bruker først predict() til å predikere logits

preds <- predict(m1, 
                 newdata = plotdata, 
                 se.fit = TRUE, 
                 type = "link")


# Trinn 4: Lagrer predikert verdi og standardfeil i plotdata

plotdata$fit <- preds$fit
plotdata$se <- preds$se.fit

# Plot uten konfidensintervaller 
ggplot(plotdata) + 
  geom_line(aes(aid, fit))

# Trinn 5: Regner ut 95% konfidensintervaller

plotdata <- plotdata %>%
  mutate(ki.lav = fit - 1.96*se, 
         ki.hoy = fit + 1.96*se)

# Trinn 6: Legger KI til i plottet 

ggplot(plotdata) + 
  geom_line(aes(aid, fit)) + 
  geom_line(aes(aid, ki.lav), linetype = "dotted") + 
  geom_line(aes(aid, ki.hoy), linetype = "dotted")

# Plotter effekter: sannsynligheter - SNARVEI #
# Vi gjenbruker trinn 1 og 2, men konfidensintervallene kan komme til å 
# gå utenfor referanseområdet

# Trinn 3: Bruker predict med type = response for å få sannsynligheter

preds2 <- predict(m1, 
                  newdata = plotdata, 
                  se.fit = TRUE, 
                  type = "response")

# Trinn 4: Lagrer informasjon om predikerte verdier og standardfeil fra predict i plotdata

plotdata$fit.prob <- preds2$fit
plotdata$se.prob <- preds2$se.fit

# Trinn 5: Lager 95 % konfidensintervaller

plotdata <- plotdata %>% 
  mutate(ki.lav.prob = fit.prob - 1.96*se.prob, 
         ki.hoy.prob = fit.prob + 1.96*se.prob)


# Trinn 6: Plotter med konfidensintervaller

ggplot(plotdata) + 
  geom_line(aes(aid, fit.prob)) + 
  geom_line(aes(aid, ki.lav.prob), linetype = "dotted") + 
  geom_line(aes(aid, ki.hoy.prob), linetype = "dotted") + 
  scale_y_continuous(limit = c(0:1))


# Sjekker om grenseverdiene til konfidensintervallene er utenfor referanseområdet

summary(plotdata$ki.lav.prob)

# Plotter effekter: sannsynligheter - MER PRESIS MÅTE #
# Her benytter vi trinn 1-4 fra da vi predikerte logits


# Trinn 5: Regner om sannsynligheter fra logits-prediksjonene og lagrer i plotdata

plotdata$ki.lav.prob2 <- exp(plotdata$fit - 1.96*plotdata$se)/(1 + exp(plotdata$fit - 1.96*plotdata$se))
plotdata$ki.hoy.prob2 <- exp(plotdata$fit + 1.96*plotdata$se)/(1 + exp(plotdata$fit + 1.96*plotdata$se))
plotdata$fit.prob2 <- exp(plotdata$fit)/(1 + exp(plotdata$fit))

# Trinn 6: Plotter

ggplot(plotdata) + 
  geom_line(aes(aid, fit.prob2)) + 
  geom_line(aes(aid, ki.lav.prob2), linetype = "dotted") + 
  geom_line(aes(aid, ki.hoy.prob2), linetype = "dotted") + 
  scale_y_continuous(limits = c(0:1))

summary(plotdata$ki.lav.prob2)

# Alle verdier er mellom 0 og 1

# Er de predikerte verdiene like?

table(plotdata$fit.prob == plotdata$fit.prob2)

## 3. Forventet verdi vs. faktisk verdi - residualer ##

# Henter ut residualer og lagrer dem i datasettet

aid$resid <- residuals(m1)

# Henter ut predikerte sannsynligheter og lagrer dem i datasettet

aid$predict <- predict(m1, type = "response")
aid$logits <- predict(m1, type = "link")

# Endrer kuttpunktet

kuttpunkt <- mean(aid$gdp_growth_d, na.rm = TRUE)


# Lager en variabel der de med predikert sannsynlighet høyere enn kuttpunktet får verdien 1

aid$growth.pred <- as.numeric(aid$predict > kuttpunkt)


# Bruker en logisk test til å sjekke om predikert verdi er lik faktisk verdi

aid$riktig <- aid$growth.pred == aid$gdp_growth_d
mean(aid$riktig, na.rm = TRUE)

# Bruker en krysstabell for å sjekke om modellen predikerer en større andel riktig
# enn om vi hadde antatt at alle land hadde vekst

tabell <- table(aid$growth.pred, aid$gdp_growth_d)

prop.table(tabell, margin = 2)

# ROC-kurve

# install.packages("plotROC")
library(plotROC)

ggplot(aid, aes(d = gdp_growth_d, m = predict)) + 
  geom_roc(labelround = 2)

