# Tuukka Lahtinen, opiskelijanumero: 2306913

# Harjoitus työ R-osuus

# luodaan vektori annetuilla arvoilla

v1=c(4.3, 6.75, 5.9, 9.12, 3, 8.2, 10.8, 1.6)

# vektorin pituus, mediaani, keskiarvo ja varianssi

length(v1)
median(v1)
mean(v1)
var(v1)

# vektori suuruus järjestykseen ja tallennetaan muuttujaan v2
v2=sort(v1)

# tulostetaan viides alkio
print(v2[5])

# vaihdetaan viidenteen alkioon luku 4

v2=replace(v2,v2==6.75,4)

# lisätään vektoriin luku 5.5
v2=append(v2, 5.5)

# luodaan v3 vektori

a=c(2,3,4)
v3=rep(a,4)
v3

# poistetaan 3 ensimmäistä alkiota v3:sta

v3=v3[-(1:3)]

#yhdistetään vektorit v2 ja v3

m1=cbind(v2,v3)

#pyöristetään 1.sarakkeen arvot

m1[, 1] <- round(m1[, 1], 1)

#luodaan matriisi m2


m2=matrix(c(4.2,3.2,8.1,10.5,7.7,4.5,5.2,6.6,5.2),nrow=3, ncol=3)
m2

# m2 transpoosi, determinantti, ominaisarvot ja dimensiot

t(m2)
det(m2)
eigen(m2)$values
dim(m2)

#korotetaan alkiot potenssiin 3

m2^3

#tehdään identiteettimatriisi
m2k=solve(m2)
im = m2%*%mk
im=round(im)
im



# 2. aineisto tehtävä


# luetaan online_sales tiedosto R:ään
library(readxl)

online_sales = read_excel("online_sales.xlsx")

# otetaan summary komento datasta
summary(online_sales)

# poistetaan rivit joilla puuttuvia havaintoja

online_sales = na.omit(online_sales)

# muutetaan aineiston otsikot suomeksi

colnames(online_sales)[1]="tilausnumero"
colnames(online_sales)[2]="päivämäärä"
colnames(online_sales)[3]="tuotenumero"
colnames(online_sales)[4]="tuote"
colnames(online_sales)[5]="hinta"
colnames(online_sales)[6]="asiakasarvio"
colnames(online_sales)[7]="käytetty"

# muutetaan päivämäärän ja hinnan sarakkeiden tyyli

online_sales$päivämäärä <- as.Date(online_sales$päivämäärä) # pvm
online_sales$hinta <- as.numeric(online_sales$hinta) # hinta


# muutetaan tuotteiden nimet ja käytetty sarake myös suomeksi
install.packages("dplyr")
library(dplyr)
online_sales = online_sales %>%
  mutate(tuote = recode(tuote,
                        "Laptop" = "Kannettava",
                        "Camera" = "Kamera",
                        "Tablet" = "tabletti",
                        "Smartphone" = "älypuhelin",
                        "Headphones" = "Kuulokkeet"),
         käytetty = recode(käytetty,
                           "yes" = "Kyllä",
                           "no" = "Ei"))

# tehdään taulukko tunnusluvuista

taulukko1 = online_sales %>%
  group_by(tuote) %>%                            
  summarize(
    maara = n(),                        
    keskihinta = mean(hinta, na.rm = TRUE),      
    mediaani = median(hinta, na.rm = TRUE),      
    kokonaismyynti = sum(hinta, na.rm = TRUE)    
  )
taulukko1


# taulukko asiakasarvioista

taulukko2 = online_sales %>%
  group_by(tuote) %>%                           # Ryhmittele tuotteen mukaan
  summarize(
    karvosana = mean(asiakasarvio, na.rm = TRUE)  # Laske arvosanojen keskiarvo
  ) %>%
  arrange(desc(karvosana)) 
taulukko2

# taulukon 2 suurin ja pienin ka

suurin = taulukko2[1, ]
pienin = taulukko2[nrow(taulukko2), ]

suurin  # suurin ka
pienin   # pienin ka


# tehdään g) kohdan mukainen kuvaaja
install.packages("ggplot2")
library(ggplot2)

#  pylväskuvio myynnistä
ggplot(taulukko1, aes(x = tuote, y = kokonaismyynti, fill = tuote)) +
  geom_bar(stat = "identity") +                  
  labs(
    title = "Tuotteiden kokonaismyynti",         
    x = "",                                      
    y = "euroa"                                 
  ) +
  theme_minimal() +                             
  theme(
    legend.title = element_blank()               
  )


# pylväskuvio, jossa tuotteet jaettu uusiin ja käytettyihin
ggplot(online_sales, aes(x = tuote, fill = käytetty)) +
  geom_bar(position = "dodge") +            
  labs(
    title = "Myytyjen tuotteiden lukumäärät  (uudet ja käytetyt)",  
    x = "Tuote",                                             
    y = "Määrä"                                        
  ) +
  scale_fill_manual(values = c("#056783", "#3f7f0e")) +      
  theme_minimal() +                                          
  theme(
    legend.title = element_blank()                            
  )


# 3. aineisto tehtävä

rakennushankkeet = read.csv("001_12fy_2024m08_20241027-123611.csv")

# tarkastellaan ja muokataan aineistoa
head(rakennushankkeet)

rakennushankkeet <- rakennushankkeet %>% select(-Rakennusvaihe, -Alue)

rakennushankkeet <- rakennushankkeet %>% rename(Asunnot_kpl = X01.Asuinrakennukset.Asunnot..kpl.)


# luodaan aikasarja 

# asunnot_kpl numeeriseksi
rakennushankkeet$Asunnot_kpl <- as.numeric(rakennushankkeet$Asunnot_kpl)

# Määritä aikasarjan aloitusajankohta (esim. vuosi 2021 ja tammikuu)
# Tässä esimerkissä 2021 ja tammikuu eli kuukausi 1
aloitusvuosi <- 1995
aloituskk <- 1

# Luo aikasarja kuukausittain
aikasarja <- ts(rakennushankkeet$Asunnot_kpl, start = c(aloitusvuosi, aloituskk), frequency = 12)

# kuvaaja aikasarjasta

plot(aikasarja,
     type = "l",                     
     col = "black",                  
     lwd = 2,                       
     lty = 1,                        
     xlab = "Vuosi",                 
     ylab = "Asuntojen lkm",  
     main = "Aloitetetut rakennushankkeet Suomessa 1995- 2024" ,
     sub= "Lähde: Tilastokeskus"
)

#vaakaviiva
keskiarvo = mean(aikasarja)
abline(h = keskiarvo, col = "red", lwd = 2, lty = 2)   

#infolaatikko
legend("topright",                            # Infolaatikon sijainti
       legend = c("Asuntojen lukumäärä", "Keskiarvo"),  # Selitteet
       col = c("black", "red"),                # Värit
       lty = c(1, 2),                         # Viivatyylit
       lwd = 1)   


# 4. aineistotehtävä

#tuodaan aineisto R:ään
library(readxl)

julkinenkulutus = read_excel("julkinen_kulutus.xlsx")

head(julkinenkulutus)
tail(julkinenkulutus)
str(julkinenkulutus)

# muokataan sarakkeiden otsikointia ja poistetaan kaksi viimeistä riviä

colnames(julkinenkulutus)[1]="vuosi"
colnames(julkinenkulutus)[2]="julkisyhteisöt"
colnames(julkinenkulutus)[3]="valtionhallinto"
colnames(julkinenkulutus)[4]="paikallishallinto"

julkinenkulutus <- head(julkinenkulutus, -2) 


# tarkistetaan vuosi sarakkeen numeerisuus ja luodaan kuvaaja

julkinenkulutus$vuosi <- as.numeric(julkinenkulutus$vuosi)

# Piirrä viivakuvio
plot(julkinenkulutus$vuosi, julkinenkulutus$paikallishallinto,
     type = "l",                            
     col = "darkgreen",                          
     lwd = 2,                               
     xlab = "",                            
     ylab = "Miljoonaa euroa",              
     main = "Paikallishallinnon vuotuiset kulutusmenot",  
     sub = "Vuodet 1975-2021"               
)


# lisätään aineistoon uusi muuttuja kasvuasteelle

julkinenkulutus$Logpaikallishallinto = log(julkinenkulutus$paikallishallinto)
julkinenkulutus$kasvuaste = c(NA, diff(julkinenkulutus$Logpaikallishallinto))  
julkinenkulutus$kasvuaste <- round(julkinenkulutus$kasvuaste, 2)




# piirretään viivakuvio kasvuasteelle
plot(julkinenkulutus$vuosi, julkinenkulutus$kasvuaste,
     type = "l",                           
     col = "blue",                          
     lwd = 2,                              
     xlab = "",                            
     ylab = "%-muutos",                    
     main = "Paikallishallinnon vuotuisten kulutusmenojen kasvuaste", 
     sub = "Lähde: Tilastokeskus"        
)

# poikkiviiva kasvuasteen nollakohtaan
abline(h = 0, col = "red", lwd = 2, lty = 2)


# kuvaaja julkisyhteisöjen ja valtionhallinnon kehityksestä

plot(julkinenkulutus$vuosi, julkinenkulutus$julkisyhteisöt,
     type = "l",                           
     col = "darkorange",                         
     lwd = 2,                              
     xlab = "",                            
     ylab = "Miljoonaa euroa",             
     main = "Julkisen kulutuksen muutos vuosittain",  
     sub = "Lähde: Tilastokeskus"          
)

lines(julkinenkulutus$vuosi, julkinenkulutus$valtionhallinto,
      col = "violet",                        # Valtionhallinto punainen
      lwd = 2)                            # Viivan paksuus

# infolaatikko
legend("topright",                       
       legend = c("Julkisyhteisöt", "Valtionhallinto"),  # Legendan tekstit
       col = c("darkorange", "violet"),           # Värit
       lty = 1,                           # Viivatyypit
       lwd = 2)                           # Viivan paksuus


