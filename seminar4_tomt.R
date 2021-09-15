#### SEMINAR 4 ####

## Plan for seminaret ##
# 1. Logistisk regresjon med glm()
# 2. Plotte effekter
# 3. Forventet verdi vs. faktisk verdi - residualer


## 1. Logistisk regresjon med glm() ##

# Laster inn datasettet


# Oppretter ny dikotom variabel


# Trinn 1: Kjører binomisk logistisk model med glm()


# Viser resultatene i en tabell med stargazer()


# Regne om til predikert sannsynlighet


## 2. Plotte effekter ##

# Plotter effekter: logits #
# Trinn 2: Vi lager et datasett med plotdata der vi lar aid variere


# Trinn 3: Bruker først predict til å predikere logits


# Trinn 4: Lagrer predikert verdi og standardfeil i plotdata


# Trinn 5: Regner ut 95% konfidensintervaller


# Trinn 6: Legger KI til i plottet 

# Plotter effekter: sannsynligheter - SNARVEI #
# Vi gjenbruker trinn 1 og 2, men konfidensintervallene kan komme til å 
# gå utenfor referanseområdet

# Trinn 3: Bruker predict med type = response for å få sannsynligheter


# Trinn 4: Lagrer informasjon om predikerte verdier og standardfeil fra predict i plotdata


# Trinn 5: Lager 95 % konfidensintervaller


# Trinn 6: Plotter med konfidensintervaller


# Sjekker om grenseverdiene til konfidensintervallene er utenfor referanseområdet


# Plotter effekter: sannsynligheter - MER PRESIS MÅTE #
# Her benytter vi trinn 1-4 fra da vi predikerte logits


# Trinn 5: Regner om sannsynligheter fra logits-prediksjonene og lagrer i plotdata


# Trinn 6: Plotter


## 3. Forventet verdi vs. faktisk verdi - residualer ##

# Henter ut residualer og lagrer dem i datasettet


# Henter ut predikerte sannsynligheter og lagrer dem i datasettet


# Endrer kuttpunktet


# Lager en variabel der de med predikert sannsynlighet høyere enn kuttpunktet får verdien 1


# Bruker en logisk test til å sjekke om predikert verdi er lik faktisk verdi


# Bruker en krysstabell for å sjekke om modellen predikerer en større andel riktig
# enn om vi hadde antatt at alle land hadde vekst


# ROC-kurve
