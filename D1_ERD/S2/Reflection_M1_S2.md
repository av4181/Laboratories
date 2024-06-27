**Team:** TIFL01_2_RB_Andreas_stef

- **Name:** Stef Henderickx (s2)
- **Studentnr:** ...

**Year:** 2023-2024

S2: Onderwerp: (2 niveaus diep)
-----------------------------
- W: Laboratory
- X: Measurement
- Y: measurement_report
- Z: measurement_Campaign

S2 Relatietypes:
-------------
- Laboratory
  - owns zero or more
  - measurements
- measurement
  - will be reported in one
  - measurement_reports
- measurement_report
  - is part of one
    - measurement_campaign
  - contains zero or more 
    - measurements
- measurement_campaign
  - has zero or more
  - measurement_reports

S2 Attributen:
--------------
- W: laboratory
  - Laboratory_ID (PK)
  - Laboratory_name
  - Laboratory_Description
  - Company
  - Laboratory_address
  - Laboratory_Location
- X: Measurement
  - Measurement_ID (PK)
  - Report_ID (FK)
  - Laboratory_ID (FK)
  - Measurement_Start_Date
  - Measurement_End_Date
  - Results
  - Unit
  - Measurement_Cost
- Y: Measurement_Report
  - Report_ID (PK)
  - Campaign_ID (FK)
  - Report_Creation_Date
  - Report_Send_date
  - Report_Receiver_ID
  - Report_Receiver_Email
  - Report_Sender_Email
  - Report_Sender_Email
  - Printed_Report
- Z: Measurement_Campaign
  - Campaign_ID (PK)
  - Campaign_Creation_Date
  - Campaign_Start_Date
  - Campaign_End_Date
  - Campaign_Description
  - Campaign_Purpose
  - Campaign_Requester_ID
  - Campaign_Requester
  - Campaign_status

