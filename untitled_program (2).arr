use context essentials2021
include shared-gdrive(
"dcic-2021",
  "1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep") 

include gdrive-sheets
include data-source
ssid = "1RYN0i4Zx_UETVuYacgaGfnFcv4l9zd9toQTTdkQkj7g"
energiforbruk =
  load-table: komponent, energi
    source: load-spreadsheet(ssid).sheet-by-name("kWh", true)
    sanitize energi using string-sanitizer #Oppgave a)
  end #Brukt sanitize for å få kolonnedata for kolonnen energi returnert som data av typen string.

energiforbruk


#Oppgave b,c)
fun energi-to-number(s :: String) -> Number: #Definer funksjon som overfører data fra String til Number
  
  cases(Option) string-to-number(s):
    |some(a) => a
    |none => 0
  end 
  
where: #Endrer bestemt data fra tekst til tall.
  energi-to-number("") is 0
  energi-to-number("30") is 30
  energi-to-number("37") is 37
  energi-to-number("5") is 5
  energi-to-number("4") is 4
  energi-to-number("15") is 15
  energi-to-number("48") is 48
  energi-to-number("12") is 12
  energi-to-number("4") is 4
end 


tabell2 = transform-column(energiforbruk, "energi", energi-to-number)
tabell2 #utskrift av den nye tabellen.



#Oppgave d) 
fun sum-on-energi(): #Definerer en funksjon for a beregne totalsummen av energi.
  sum(tabell2, "energi") 
  end


sum-on-energi() #Vise totalsummen av energiforbruk i definisjonsvinduet(155).


utslipp-norge = transform-column(tabell2, "bil", energi-to-number) 
#Definerer gjennomsnittlig kwh-forbruk på bil per person i Norge.

distance = 15
distance-per-unit-of-fuel = 1.5
energi-per-unit-of-fuel = 2

energi-per-day = (distance / distance-per-unit-of-fuel) * energi-per-unit-of-fuel

fun bilforbruk-norge(value :: Number) -> Number:
  if value == 0: energi-per-day 
  else: value 
  end 
end

total = transform-column(utslipp-norge, "energi", bilforbruk-norge)
sum-on-energi() + energi-per-day #Skriver ut summen av kWh for alle komponenter (175). 


#Oppgave e) Visualisering av data. 
chart = table: komponent :: String, energi :: Number
  row: "bil", 20
  row: "fly", 30
  row: "ovn", 37
  row: "lys", 5
  row: "dingser", 4
  row: "mlk", 15
  row: "varer", 48
  row: "varetransport", 12
  row: "offtjen", 4
end

bar-chart(chart, "komponent", "energi")  #skriver ut tabell2 som image.