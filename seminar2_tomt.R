#### SEMINAR 2 - GRUPPE 2 #### 

## Plan for seminaret ## 
# 1. Laste inn data - read_funksjoner()
# 2. Forberede og manipulere data
# 3. Utforsking av data og deskriptiv statistikk
# 4. Plotte-funksjonen ggplot
# 5. Lagre datasett


## 1. Laste inn data - read_funksjoner() ## 

# Installere/hente tidyverse og haven 


## 2. Forberede og manipulere data ##

# Hva er enhentene i datasettet?


# Hva heter variablene i datasettet?


# Hva slags klasse har variablene?


# Er det manglende informasjon på noen av variablene vi er interesserte i?


# Noen omkodingsfunksjoner

## data$ny_var <- funksjon(data$gammel_var)
# Vi anvender en funksjon som omarbeider informasjonen i en gammel variabel i 
# datasettet vårt, og legger den til datasettet vårt med et nytt navn


# Omkoding med tidyverse/dplyr og matematisk omkoding


# Endre klassen til variabelen 


# Omkoding med ifelse()

## data$nyvar <- ifelse(test = my_data$my.variabel == "some logical condition",
##        yes  = "what to return if 'some condition' is TRUE",
##        no   = "what to return if 'some condition' is FALSE")


# Endre datastruktur ved hjelp av aggregering


## 3. Utforsking av data og deskriptiv statistikk ## 

# Univariat statistikk for kontinuerlige variabler 


# Bivariat/multivariat statistikk for kontinuerlige variabler 


# Kategoriske variabler


## 4. Plotte-funksjonen ggplot ##

# geom_histogram()


# geom_boxplot()


# geom_line()


# geom_point()

## Lagre datasett ## 

