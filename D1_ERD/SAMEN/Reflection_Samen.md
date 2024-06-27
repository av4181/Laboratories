
**Team:** TIFL01_2_RB_andreas_Stef

- **Name:** Andreas van Loon (S2)
- **Studentnr:** ...
- **Class:** TIFL01


- **Name:** Stef Henderickx (S2)
- **Studentnr:** 0123456789
- **Class:** TIFL01

**Year:** 2023-2024


S1: Onderwerp: (veel op veel) 
------------------------------------
- A: Labtechnician
- B: Sample
- C: Instrument
- D: Measurement



S1 Relatietypes:
-------------
- Lab_technician 
  - Performs one or more measurements 
  - Belongs to one or more laboratories
- Sample 
  - one or more measurements can be preformed on a sample
  - a sample can go to one or more laboratories
  - a sample can be moving to a laboratory and thus not linked to a laboratory
- Instrument 
  - One or more instruments can be used on a measurement
- laboratory
  - a laboratory has one zero or more lab_technicians
  - a laboratory has zero or more samples. 
- measurements
  - is done on one sample
  - is done by one lab_technician
  - needs one Instrument


S1 Attributen:
-----------
- **A: lab_technician**
- Technician_ID (PK)
- Laboratory_ID (FK)
- Supervisor_ID (FK)
- First_name 
- Last_name 
- Gender
- Function
- Start_Date
- End_Date
- Address

- **B: Sample**
- Sample_ID (PK)
- Laboratory_ID (FK)
- Description
- Status
- Sampling_Date
- SamplePoint
- Sample_Type

- **C: Instrument**
- Instrument_ID (PK)
- Description 
- Name 
- Cost

- **D: Measurement**
- Measurement_ID (PK)
- Technician_ID (FK)
- Instrument_ID (FK)
- Sample_ID (FK)
- Measurement_Start_Date
- Measurement_End_Date
- Result
- Unit
- Measurement_Cost

  
2: Onderwerp: (2 niveaus diep)
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
- **W: laboratory**
  - Laboratory_ID (PK)
  - Laboratory_name
  - Laboratory_Description
  - Company
  - Laboratory_address
  - Laboratory_Location
- **X: Measurement**
  - Measurement_ID (PK)
  - Report_ID (FK)
  - Laboratory_ID (FK)
  - Measurement_Start_Date
  - Measurement_End_Date
  - Results
  - Unit
  - Measurement_Cost
- **Y: Measurement_Report**
  - Report_ID (PK)
  - Campaign_ID (FK)
  - Report_Creation_Date
  - Report_Send_date
  - Report_Receiver_ID
  - Report_Receiver_Email
  - Report_Sender_Email
  - Report_Sender_Email
  - Printed_Report
- **Z: Measurement_Campaign**
  - Campaign_ID (PK)
  - Campaign_Creation_Date
  - Campaign_Start_Date
  - Campaign_End_Date
  - Campaign_Description
  - Campaign_Purpose
  - Campaign_Requester_ID
  - Campaign_Requester
  - Campaign_status


Samen: Extra Entiteittypes:
--------------
- measurement
- laboratory

Relatietypes:
-------------
- **measurement**
  - will be reported in one measurement_reports
  - is done on one sample
  - is done by one lab_technician
  - needs one Instrument

- **laboratory**
  - a laboratory has one zero or more lab_technicians
  - a laboratory has zero or more samples.
  - owns zero or more measurements ==> relation can be seen through other tables
    

SAMEN Attributen:
--------------
**Measurement**
- Measurement_ID (PK)
- Technician_ID (FK)
- Instrument_ID (FK)
- Sample_ID (FK)
- Report_ID (FK)
- Measurement_Start_Date
- Measurement_End_Date
- Results
- Unit
- Measurement_Cost

**laboratory**
- Laboratory_ID (PK)
- Laboratory_name
- Laboratory_Description
- Company
- Laboratory_address
- Laboratory_Location
