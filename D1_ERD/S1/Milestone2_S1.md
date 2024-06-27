Name: Andreas Van Loon

Year: 2023-2024

Milestone 2: Modelling S1
---
TOP DOWN MODELLING
---

Conceptual Model
---

    Entitytypes + Attributes + PK
---
- A: Sample (**Sample_ID**, Description, Status, Sampling_Date, SamplePoint, Sample_Type, Products)
- B: Laboratory (**Laboratory_ID**, Laboratory_Name, Laboratory_Description, Company, Laboratory_Address, Laboratory_Location)
- C: Lab_Technician (**Technician_ID**, Supervisor_ID, Function, First_name, Last_name, Gender, Function_Start_Date, Function_End_Date, Address)
- C: Measurement ( **measurement_id**, Measurement_Start_date, Measurement_End_Date, Result, unit, measurement_Cost,Technician_ID, Instrument_ID, Sample_ID, Laboratory_ID, Report_ID)
measurement moet D zijn
- D: Instrument ( **Instrument_ID**, Instrument_Description, Instrument_Name, Instrument_Cost)

Domains - constraints
--- 
- Measurement: Measurement_End_Date > Measurement_Start_Date
- Measurement: Result > 0
- Measurement: Measurement_Cost - must contain €
- Sample: Description - minimum 3 characters
- Sample: Status - minimum 2 characters
- Instrument: Instrument_Description - minimum 3 characters
- Instrument: Instrument_Cost - must contain €
- Lab_Technician: gender - M/V
- Lab_Technician: Function_End_Date > Function_Start_Date


Tijd
---
- Sample: Sampling_date
- Measurement: the date on which a measurement started and ended
- Lab_Technician: the date the technician started working for the lab and if applicable the date he resigned.

Intermediërende  entiteiten
---
- There is a many-to-many relationship between samples and laboratories
- Measurement and Technician tables act as intermediary tables.  The labtechnician identifies the laboratory that
 is performing a certain measurement

Conceptual ERD
---

![Conceptual](/D1_ERD/S1/ERD_ABCD_Conceptual.png)

Logical Model
---

    Intermediating  entities
---
- Laboratory: Lab_Technician - Measurements


    Logical ERD
---

![Logical](/D1_ERD/S1/ERD_ABCD_Logical.png)

Differences after Normalisation
---
- No difference between logical model and normalisation

![Logical](/D1_ERD/S1/ERD_ABCD_Logical.png)

informatiebehoefte + Normalisatie
---
    S1:

[InformatieBehoefteS1.docx](/D2_NORMALISATIE/S1_normalisatie/InformatieBehoefteS1.docx)

[OverzichtsDocument_v3.pdf](/D2_NORMALISATIE/S1_normalisatie/OverzichtsDocument_v3.pdf)