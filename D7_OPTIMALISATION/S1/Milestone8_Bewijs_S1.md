## Milestone 8 Bewijs S1

****

### Overzicht vergelijking:

![Overzicht_Vergelijking.png](Screenshots%2FOverzicht_Vergelijking.png)

### Tabel voor partionering:

![M8_TabelGrootte_Voor_S1.png](Screenshots%2FM8_TabelGrootte_Voor_S1.png)

### Query:

![Query_S1.png](Screenshots%2FQuery_S1.png)

### Explain plan:

![M8_Explain_Plan_Voor_S1.png](Screenshots%2FM8_Explain_Plan_Voor_S1.png)

![M8_Explain_Plan_Voor_S1_02.png](Screenshots%2FM8_Explain_Plan_Voor_S1_02.png)

### Tabel na partionering:

#### Partitie script + uitvoering partitie sleutel

Vaststellingen en strategie:
- Full table scans op tabellen MEASUREMENTS, SAMPLES en LABORATORIES
- Alle rijen worden dus doorzocht in die 3 tabellen
- Overwegingen :
  - indexen creëeren op Sample_Status en Measurement_Start_Date (niet uitgevoerd)
  - Partitionering MEASUREMENTS op Measurement_Start_Date (datums worden nu generereert tot 10 dagen geleden)

![Partitie_S1.png](Screenshots%2FPartitie_S1.png)

#### Tabel info na partionering en indexing

![M8_TabelGrootte_Na_S1.png](Screenshots%2FM8_TabelGrootte_Na_S1.png)

#### Partities

![Aantal_Partities_S1.png](Screenshots%2FAantal_Partities_S1.png)

Er werden 12 partities gemaakt.  De random functies genereren measurement 
start dates tot 10 dagen geleden (moment screenshot 25MAY2024).  Voor alle 
datums hiervoor werd een partities gevormd waar alle andere partities invallen.

#### Explain plan NA

![M8_Explain_Plan_Na_S1.png](Screenshots%2FM8_Explain_Plan_Na_S1.png)

![M8_Explain_Plan_Na_S1_02.png](Screenshots%2FM8_Explain_Plan_Na_S1_02.png)

### Conclusie:
Het primaire doel van partitionering is het verbeteren van de queryprestaties. 
Aangezien onze S1 query zich richt op een specifieke maand, zou partitionering 
per maand een logische keuze zijn.

De totale kost is na partitionering nu 14 in plaats van 530, dus een besparing 
van ca. 97%. Het grootste aandeel van de cost zit in FULL table scans.  
Na partionering
wordt er nog steeds een full table scan uitgevoerd, met dat verschil dat het enkel op 
de partionering gebeurt.  Zodra de query aangepast wordt en de WHERE clausule
niet meer compatibel is met de partitionering, vervalt de winst en bepaalt de optimizer
om eventueel alsnog een FULL table scan uit te voeren.

Het geheugen is na partitionering ook gestegen van 27MB naar 88MB.

