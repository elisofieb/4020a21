#### SEMINAR 2 - GRUPPE 2 #### 

## Plan for seminaret ## 
# 1. Laste inn data - read_funksjoner()
# 2. Forberede og manipulere data
# 3. Utforsking av data og deskriptiv statistikk
# 4. Plotte-funksjonen ggplot
# 5. Lagre datasett


## 1. Laste inn data - read_funksjoner() ## 

# Installere/hente tidyverse og haven 

install.packages("haven")
library(haven)
aid <- read_dta("https://cdn.jsdelivr.net/gh/martigso/stv4020aR21/seminar2/aid.dta")

library(tidyverse)

## 2. Forberede og manipulere data ##

# Hva er enhentene i datasettet?

str(aid)
head(aid, 10)
tail(aid, 10)
sample_n(aid, 5)

# Hva heter variablene i datasettet?
names(aid)

# Hva slags klasse har variablene?
class(aid$inflation)

# Er det manglende informasjon på noen av variablene vi er interesserte i?
table(complete.cases(aid))
table(is.na(aid))
table(is.na(aid$gdp_growth))

# Noen omkodingsfunksjoner

## data$ny_var <- funksjon(data$gammel_var)
# Vi anvender en funksjon som omarbeider informasjonen i en gammel variabel i 
# datasettet vårt, og legger den til datasettet vårt med et nytt navn


# Omkoding med tidyverse/dplyr og matematisk omkoding

aid$policy_index <- aid$inflation + aid$budget_balance + aid$economic_open

aid <- aid %>% mutate(policy_index = inflation + budget_balance + economic_open)

aid <- aid %>% mutate(policy_index = inflation + budget_balance + economic_open,
                      policy_sent = policy - mean(policy, na.rm = TRUE)) %>%
               rename(policy2 = policy_index)

# aid <- aid %>% rename(policy2 = policy_indeks) %>% mutate(policy_indeks = inflation + budget_balance + 
# economic_open, policy_sent = policy - mean(policy, na.rm = TRUE)) #FEIL
                        

# Endre klassen til variabelen 
aid$period_ch <- as.character(aid$period)


# Omkoding med ifelse()

## data$nyvar <- ifelse(test = my_data$my.variabel == "some logical condition",
##        yes  = "what to return if 'some condition' is TRUE",
##        no   = "what to return if 'some condition' is FALSE")

# Eksempel på enkel bruk av ifelse()
# data$vote_dich <- ifelse(data$vote == "voted", 1, 0) 

aid <- aid %>% mutate(decade = ifelse(periodstart < 1980, "70s",
                                      ifelse(periodstart > 1980 & periodstart < 1990, "80s", "90s")))

table(aid$decade, aid$periodstart, useNA = "always")

# Endre datastruktur ved hjelp av aggregering - group_by() og summarise()

aid <- aid %>% mutate(region = ifelse(sub_saharan_africa == 1, "Sub-Saharan Africa",
                                      ifelse(central_america == 1, "Central America",
                                             ifelse(fast_growing_east_asia == 1, "East Asia", "Other"))))

table(aid$region, aid$sub_saharan_africa, useNA = "always")

aid %>% group_by(region) %>%
  summarise(neigh_growth = mean(gdp_growth, na.rm = TRUE),
            n_region = n())

aid2 <- aid %>% group_by(region) %>%
  summarise(neigh_growth = mean(gdp_growth, na.rm = TRUE),
            n_region = n())

# Legger til neigh_growth og n_region som variabler med mutate() (her bruker vi ikke summarise)
aid <- aid %>% group_by(region) %>% mutate(neigh_growth = mean(gdp_growth, na.rm = TRUE),
                                              n_region = n()) %>% ungroup()


## 3. Utforsking av data og deskriptiv statistikk ## 

# Univariat statistikk for kontinuerlige variabler 
summary(aid$gdp_growth)


# Bivariat/multivariat statistikk for kontinuerlige variabler 
cor(aid$gdp_growth, aid$aid, use = "pairwise.complete.obs")
cor.test(aid$gdp_growth, aid$gdp_pr_capita)

str(aid)
aid %>% select(6:13) %>% cor(., use = "pairwise.complete.obs")

# Kategoriske variabler
table(aid$region)
prop.table(table(aid$region))

# Tabell med flere variabler
table(aid$gdp_growth > median(aid$gdp_growth, na.rm = TRUE))

## 4. Plotte-funksjonen ggplot ##

ggplot(datasettet, aes(x = navnpåvariabel, y = navnpåvariabel, col = navnpåvariabel)) + geom_navnpågraf/plott()

ggplot(aid, aes(region)) + geom_bar() + ggtitle("Mitt plott")

# geom_histogram()

ggplot(aid, aes(gdp_growth)) + geom_histogram(binwidth = 5)


# geom_boxplot()
ggplot(aid, aes(as.factor(region), aid)) + geom_boxplot()

# geom_line()
ggplot(aid, aes(period, gdp_growth, col = country)) + geom_line()

aid %>% filter(region == "Sub-Saharan Africa") %>%
  ggplot(aes(period, gdp_growth, col = country)) + geom_line()

aid %>% filter(country %in% c("KEN", "ETH", "NGA", "GAB")) %>%
  ggplot(aes(period, gdp_growth, col = country)) + geom_line()

# geom_point()

ggplot(aid, aes(aid, gdp_growth, col = policy)) + geom_point()
ggplot(aid, aes(aid, gdp_growth, col = region)) + geom_point()

ggplot(aid, aes(aid, gdp_growth, col = region)) + geom_point() + geom_smooth(method = "lm")
ggplot(aid, aes(aid, gdp_growth)) + geom_point() + geom_smooth(method = "lm")

ggplot(aid, aes(aid, gdp_growth)) + geom_point() + geom_smooth(method = "lm") + 
  ggtitle("Forholdet mellom aid og gdp_growth") + xlab("Økonomisk bistand") + 
  ylab("Økonomisk vekst") + theme_bw()

# Lagre plott i working directory/R-project
ggsave("mittplot.png")

## Lagre datasett ## 

save(aid, file = "aid.RData")

# Laste inn .RData
load("aid.RData")

