#### SEMINAR 1 #### 

## Plan for seminaret ## 
# 1. Objekter
# 2. Intro til R
# 3. Logiske tester 
# 4. Pakker
# 5. Indeksering
# 6. Ulike typer vektorer i R
# 7. Funksjoner i R
# 8. Laste inn data

## Objekter ##

# Navn

# Alder 

# Bachelor

# Datasett


## Intro til R ## 

# Ikke objekt eller plot


# R som kalkulator 

1 + 1  # addisjon
2 - 3  # subtraksjon
4/2    # divisjon
2 * 2  # multiplikasjon
2^3    # potens
exp(2) # eksponentiering
log(2) # logaritme (default er naturlig logaritme)
2 * (4-2)/(4-2) # Parentesregler fungerer som i vanlig algebra: den innerste parentesen regnes ut først


## Logiske tester ## 

# Logiske utsagn
1 == 2                                # tester om 1 er lik 2
2 == 2                                # tester om 2 er lik 2
"Statsvitenskap" == "statsvitenskap"  # Logiske tester kan også brukes på tekst
"statsvitenskap" == "statsvitenskap"  # R er imidlertid sensitivt til store og små bokstaver
1 <= 2                                # Tester om 1 er mindre enn eller lik 2
1 >= 2                                # Tester om 1 er større enn eller lik 2
1 != 2                                # Tester om 1 er ulik 2
1 == 2 | 1 == 1                       # Tester om en av de to påstandene 1 er lik 2 eller 1 er lik 1 er sanne
1 == 2 & 1 == 1                       # Tester om begge de to påstandene 1 er lik 2 og 1 er lik 1 er sanne


## Pakker ##

## install.packages("pakkenavn") # Laster ned filene pakken består av fra nett til PC - må bare gjøres en gang
## library(pakkenavn)            # Tilgjengeliggjør pakken i R-sesjonen, må gjøres hver gang du vil bruke pakken i en ny sesjon


## Indeksering ## 

# Endimensjonal vektor 



# Todimensjonal vektor

# For todimensjonale vektorer så gjelder dette generelt:
# data[rad, kolonne] henter ut en gitt rad og en gitt kolonne 
# data[rad, ] henter ut en alle kolonner for en gitt rad
# data[, kolonne] henter ut alle rader for en gitt kolonne

# Informasjon om en variabel/kolonne


# Informasjon om en variabel/kolonne for en observasjon/rad


## Ulike typer vektorer i R ## 

"Atomic vector" <- c("numeric", "integer", "character", "factor", "logical")
"List" <- c("blanding", "", "", "", "")
tabell <- cbind(`Atomic vector`, List)

# Hvilket format tror du navn, alder og bachelor har? Dette kan vi sjekke med class().

# Bruk av glimpse() for å få en oversikt over alle variablene i data og deres format.

# Endre formatet/typen til en variabel


## Funksjoner i R ##

aFunction(x = "R-objekt", arg = "alternativ for figurens oppførsel")
## Merk: dette er ikke en faktisk funksjon i R. Funksjoner kan også ha andre syntakser. 

# Bruk av hjelpefiler

# Bruk av funksjoner for å få mer informasjon om datasettet vårt


## Laste inn data ## 

# Sjekke hva som er working-directory 


# Endre working directory 
setwd("C:/Users/Navn/R/der/du/vil/jobbe/fra")   # For windows
setwd("~/R/der/du/vil/jobbe/fra")               # For mac/linux
# Merk at R bruker / for å skille mellom mappenivåer, mens filutforsker i Windows bruker \ 
# Kopierer du mappebanen fra filutforsker må du derfor huske å snu skråstrekene i R

# Alternativ: starte et nytt "Project" 


# Laste inn ulike typer data

library(tidyverse) # read_funksjoner fra readr i tidyverse
datasett <- read_filtype("filnavn.filtype") # Laster inn og lagrer datasettet som et objekt
read_csv("filnavn.csv") # for .csv, sjekk også read.table
load("") # For filer i R-format.

library(haven) # Fra haven-pakken - dette skal vi se på i senere seminar
read_spss("filnavn.sav")  # for .sav-filer fra spss
read_dta("filnavn.dta") # for .dta-filer fra stata
