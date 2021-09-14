#### SEMINAR 3 ####

## Plan for seminaret ##
# 1. Laste inn pakker og forberede data (repetisjon)
# 2. Lineær regresjon (OLS)
# 3. Hvordan plotter vi resultater fra OLS?
# 4. Hvordan slår vi sammen flere datasett?


## 1. Laste inn pakker og forberede data (repetisjon) ##

# Henter pakker 


# Forbereder data


# 2. Lineær regresjon (OLS)

# Syntaks 

# Bivariat regresjon

# Multivariat regresjon 


# Samspill 


# Andregradsledd og andre omkodinger 


# Fine tabeller med stargazer()


# 3. Hvordan plotter vi resultater fra OLS?

# Kjører en redusert modell


# Lager datasett hvor kun den uavhengige variabelen, som vi vil plotte effekten, varierer


# Bruker predict()


# Legger predikerte verdier inn i snitt_data


# Lager et plott


# Plotter resultater for en modell med samspill 


# Fjerner objekt fra enviroment med rm()


# 4. Hvordan slår vi sammen flere datasett?

# Laster inn datasettet equality med read_csv()


# Hvilker variabler har aid og equality til felles?


# Bruker logisk test for å sjekke om aid$country og equality$country_text_id matcher


# Sjekker hvilke observasjoner som ikke matcher


# Oppretter periode-variabel i equality-datasettet


# Endrer på datastrukturen til equality for at det skal matche aid 


# Kombinerer equality_agg og aid med left_join()


# Sjekker missing


# Henter ut informasjon om variabelen aid2$avg_eq i det nye datasettet
