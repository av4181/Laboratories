## Milestone 8 Bewijs

**Stef Hendericks - Andreas Van Loon**

### STAT en controle Grootte tabel:

![Overzicht_Vergelijking.png](../S2/Screenshots/StatsEnGrootte.png)

### Tabel voor partionering:

![M8_TabelGrootte_Voor_S1.png](../S2/Screenshots/bewijs_tabel_grootte.png)

### Query:

![Query_S1.png](../S2/Screenshots/Query.png)

### Explain plan:

![M8_Explain_Plan_Voor_S1.png](../S2/Screenshots/Explain%20Plan%20Query.png)

### grant rights to SAMEN

![grant_S2.png](../S2/Screenshots/grant_create_samen.png)

### Create materialized view
![create_view_S2.png](../S2/Screenshots/Create_Material_View.png)

#### select results via view

![select_view_S2.png](../S2/Screenshots/Select%20view.png)

#### Explain plan Materialized view

![M8_Explain_Plan_view_S2.png](../S2/Screenshots/Select%20view%20explain%20plan.png)

### Moeilijkheden:

De moeilijkheid voor mij was hier het kiezen van een juiste refresh mode.
Initieel wou ik de mode op REFRESH FAST zetten.
Dit werd echter gewijgerd door mijn DBMS. 

Na wat opzoek werk in de oracle documentatie werd het duidelijk dat dit een incrementiele 
refresh was en dit niet te combineren is met 'BUILD IMMEDIATE'.

Bij 'BUILD IMMEDIATE' kan enkel een complete refresh gedaan worden. 
Verder had ik ook nog gelezen dat je dit op on commit en on demand gezet kan worden.
Hier heb ik gekozen voor on demand zodat de query waaruit de view bestaat niet bij elke commit
opnieuw uitgevoerd moeten worden.

### Conclusie:
Een materialized view slaagt zijn resultaten op en is daarom performanter. 
Hij haalt de resultaten hierdoor sneller op omdat hij het resultaat niet nog moet 'bouwen' maar kan 
uitlezen uit het geheugen.

Een Materialized view kan nadelig zijn wanneer het gebruikt wordt voor een tabel die veel aangepast moet
worden. Hierdoor moet de query (waar de view mee gemaakt is) vaker herhaalt worden en kan dit nadelige
effecten hebben op de performantie.


