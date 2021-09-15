#### SEMINAR 2 - GRUPPE 2 #### 

## Plan for seminaret ## 
# 1. Laste inn data - read_funksjoner()
# 2. Forberede og manipulere data
# 3. Utforsking av data og deskriptiv statistikk
# 4. Plotte-funksjonen ggplot
# 5. Lagre datasett


## 1. Laste inn data - read_funksjoner() ## 

# Installere/hente tidyverse og haven 
library(tidyverse)
library(haven)
aid <- read_dta("https://cdn.jsdelivr.net/gh/martigso/stv4020aR21/seminar2/aid.dta")

## 2. Forberede og manipulere data ##

# Hva er enhentene i datasettet?

str(aid)
head(aid, 10)
tail(aid, 7)
sample_n(aid, 10)

# Hva heter variablene i datasettet?

names(aid)

# Hva slags klasse har variablene?

class(aid$period)
summary(aid)
str(aid)

# Er det manglende informasjon på noen av variablene vi er interesserte i?

table(complete.cases(aid))
table(is.na(aid$gdp_growth))
table(is.na(aid))

# Noen omkodingsfunksjoner

## data$ny_var <- funksjon(data$gammel_var)
# Vi anvender en funksjon som omarbeider informasjonen i en gammel variabel i 
# datasettet vårt, og legger den til datasettet vårt med et nytt navn

aid$policy_index <- aid$inflation + aid$budget_balance + aid$economic_open

# Omkoding med tidyverse/dplyr og matematisk omkoding

aid <- aid %>% mutate(policyindeks = inflation + budget_balance + economic_open)

aid <- aid %>% mutate(policy_index = inflation + budget_balance + economic_open, 
                          policy_sent = policy - mean(policy, na.rm = TRUE)) %>% rename(policy2 = policy_index) 

# Endre klassen til variabelen 

aid$inflation_ch <- as.character(aid$inflation)
glimpse(aid)

# Omkoding med ifelse()

## data$nyvar <- ifelse(test = my_data$my.variabel == "some logical condition",
##        yes  = "what to return if 'some condition' is TRUE",
##        no   = "what to return if 'some condition' is FALSE")

data$nystemt <- ifelse(data$stemt == "stemt", 1, 0)
data$kjonn <- ifelse(data$kjonn == "Kvinne", 1, 0)

aid <- aid %>% mutate(decade = ifelse(periodstart < 1980, "70s",
                                      ifelse(periodstart > 1980 & periodstart < 1990, "80s", "90s")))

table(aid$decade, aid$periodstart)

# Endre datastruktur ved hjelp av aggregering - group_by() og summarise()

aid <- aid %>% mutate(region = ifelse(sub_saharan_africa == 1, "Sub-Saharan Africa", 
                      ifelse(central_america == 1, "Central America", 
                             ifelse(fast_growing_east_asia == 1, "East Asia", "Other"))))

# alternativ 
aid$region <- ifelse(aid$sub_saharan_africa == 1, "Sub-Saharan Africa", 
                     ifelse(aid$central_america == 1, "Central America", 
                            ifelse(aid$fast_growing_east_asia == 1, "East Asia", "Other")))

table(aid$region, aid$sub_saharan_africa)

aid2 <- aid %>%
  group_by(region) %>%
  summarise(neigh_growth = mean(gdp_growth, na.rm = TRUE), 
            n_region = n())

aid <- aid %>%
        group_by(region) %>%
        mutate(neigh_growth = mean(gdp_growth, na.rm = TRUE), 
               n_region = n()) %>%
        ungroup()

## 3. Utforsking av data og deskriptiv statistikk ## 

# Univariat statistikk for kontinuerlige variabler 

summary(aid)
summary(aid$inflation)

# Bivariat/multivariat statistikk for kontinuerlige variabler 

cor(aid$gdp_growth, aid$aid, use = "pairwise.complete.obs")
cor.test(aid$gdp_growth, aid$aid)

# Kategoriske variabler

table(aid$region)
prop.table(table(aid$region))

# Tabeller med flere variabler 

table(aid$gdp_growth > mean(aid$gdp_growth, na.rm = TRUE))
table(aid$gdp_growth > median(aid$gdp_growth, na.rm = TRUE))

## 4. Plotte-funksjonen ggplot ##

ggplot(aid, aes(region)) + geom_bar() + ggtitle("Mitt plott")

# geom_histogram()

ggplot(aid, aes(gdp_growth)) + geom_histogram()
ggplot(aid, aes(gdp_growth)) + geom_histogram(binwidth = 0.5)
ggplot(aid, aes(gdp_growth)) + geom_histogram(bins = 15)

# geom_boxplot()

ggplot(aid, aes(region, aid)) + geom_boxplot()


# geom_line()

ggplot(data = aid, aes(x = period, y = gdp_growth, col = country)) + geom_line()

aid %>% filter(region == "Sub-Saharan Africa") %>%
  ggplot(aes(x = period, y = gdp_growth, col = country)) + geom_line()

aid %>% filter(country %in% c("BWA", "ETH", "KEN", "MWI")) %>%
  ggplot(aes(x = period, y = gdp_growth, col = country)) + geom_line()

# geom_point()

ggplot(aid, aes(aid, gdp_growth, col = region)) + geom_point()

ggplot(aid, aes(aid, gdp_growth, col = region)) + geom_point() + 
  labs(title = "Spredningsplott", y = "Økonomisk vekst", x = "Bistand") + 
  theme_bw()

ggplot(aid, aes(aid, gdp_growth)) + geom_point() + geom_smooth(method = "lm")

ggsave("mittplott.png")

## Lagre datasett ## 

save(aid, file = "mittdatasett.RData")
