Milestone 3: Creatie Databank
---

    Identity columns
---
- Mandatory
    - Instruments: Instrument_ID
    - Lab_Technician: Technician_ID
    - Measurements: Measurement_ID
    - Sample: Sample_ID
- other:
    - Laboratories: Laboratory_ID


      Table Counts
---
![TableCount](/D5_QUERY/S1/Screenshots/TableCount.png)

    @query 1: Relatie Veel-op-veel
    SELECT LABORATORY_NAME, LABORATORY_DESCRIPTION,SAMPLE_DESCRIPTION,FIRST_NAME, LAST_NAME
    FROM LABORATORY l
    JOIN MEASUREMENT m ON m.LABORATORY_ID=l.LABORATORY_ID
    JOIN SAMPLE s ON s.SAMPLE_ID=m.SAMPLE_ID
    JOIN LAB_TECHNICIANS lt on l.LABORATORY_ID = lt.LABORATORY_ID;

![VeelOpVeel](/D5_QUERY/S1/Screenshots/BEwijs_Veel_op_Veel.png)
--- 


    @query 2: Instruments 

![Instruments](/D5_QUERY/S1/Screenshots/Bewijs_Niet_Eerder_Getoond.png)
--- 

Bewijs constraints M2
---
    Measurement: Measurement_End_Date > Measurement_Start_Date
![MeasurementDate](/D5_QUERY/S1/Screenshots/Bewijs_Measurement_Start_End_Date.png)

    Measurement: Result > 0
![MeasurementResult](/D5_QUERY/S1/Screenshots/Bewijs_Measurement_Result.png)

    Sample: Description - minimum 3 characters
![SampleDescription](/D5_QUERY/S1/Screenshots/Bewijs_Sample_Description.png)

    Sample: Status - minimum 2 characters
![SampleStatus](/D5_QUERY/S1/Screenshots/Bewijs_Sample_Status.png)

    Instrument: Instrument_Description - minimum 3 characters
![SampleDescription](/D5_QUERY/S1/Screenshots/Bewijs_Sample_Description.png)

    Instrument: Instrument_Cost - must contain €
![InstrumentCost](/D5_QUERY/S1/Screenshots/Bewijs_Instrument_Cost.png)

    Lab_Technician: gender - M/V
![Gender](/D5_QUERY/S1/Screenshots/Bewijs_Lab_Technician_Gender.png)

    Lab_Technician: Function_End_Date > Function_Start_Date
!![FunctionStartDate](/D5_QUERY/S1/Screenshots/Bewijs_Lab_Technician_Function_Start_End_Date.png)