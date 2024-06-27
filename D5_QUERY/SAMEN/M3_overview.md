
Milestone 3: Creatie Databank en Security
---

    Identity columns
---
Mandatory:
- A: Lab_Technicians: **Technician_ID**
- B: Samples: **Sample_ID**
- C: Instruments:  **Instrument_ID**
- D: Measurements:  **measurement_id**
- W: Laboraatories: **Laboratory_ID**
- Z: Measurements: **Measurement_ID**
- Y: Reports: **Report_ID**
- x: Campaigns: **Campaign_ID**
- Contacts: **Person_ID**

      Table Counts
---
     Tablecounts
![count_result.png](../SAMEN/Screenshots/Count.jpg)

Queries
--- 
    S1 @query 1:  Laboratories - Lab_Technicians (A) - Measurements(D) - Samples(B)
![S1_query1_veel_op_veel.png](../S1/Screenshots/BEwijs_Veel_op_Veel.png)

    S1 @query 2:  Measurements (D) - Lab_Technicians (A) - Instruments (C)
![S1_query2_.png](../S1/Screenshots/Bewijs_Niet_Eerder_Getoond.png)

    S2 @query 1:  measurements (X) - reports(Y) - campaigns(Z)
![S2_query1_2 diep.png](../SAMEN/Screenshots/2%20diep%20S2.jpg)

    S2 @query 2: reports (Y) - contacts - CAMPAIGNS (Z)
![S1_query2_niet eerder getoonde tabellen.png](../SAMEN/Screenshots/niet%20eerder%20S2.jpg)

Bewijs Domeinen - constraints M2
--- 

    S1
- Measurement: Measurement_End_Date > Measurement_Start_Date
  ![S1_bewijs_video_duration.png](../S1/Screenshots/Bewijs_Measurement_Start_End_Date.png)
- Measurement: Result > 0
  ![S1_bewijs_video_duration.png](../S1/Screenshots/Bewijs_Measurement_Result.png)
- Sample: Description - minimum 3 characters
  ![S1_bewijs_video_duration.png](../S1/Screenshots/Bewijs_Sample_Description.png)
- Sample: Status - minimum 2 characters
  ![S1_bewijs_video_duration.png](../S1/Screenshots/Bewijs_Sample_Status.png)
- Instrument: Instrument_Description - minimum 3 characters
  ![S1_bewijs_video_duration.png](../S1/Screenshots/Bewijs_Instrument_DescriptionResult.png)
- Instrument: Instrument_Cost - must contain €
  ![S1_bewijs_video_duration.png](../S1/Screenshots/Bewijs_Instrument_Cost.png)
- Lab_Technician: gender - M/V
  ![S1_bewijs_video_duration.png](../S1/Screenshots/Bewijs_Lab_Technician_Gender.png)
- Lab_Technician: Function_End_Date > Function_Start_Date
  ![S1_bewijs_video_duration.png](../S1/Screenshots/Bewijs_Lab_Technician_Date.png)

    S2
- Campaigns: Campaign_Status in ( Campaign_Start_Date >= Campaign_Creation_Date )
  ![S2_bewijs_video_duration.png](../S2/Screenshots/Campaign_Date_start_Creation_constraint.jpg)
- Campaigns: Campaign_End_Date > Campaign_Start_Date
  ![S2_bewijs_video_duration.png](../S2/Screenshots/Campaign_Date_start_end_constraint.jpg)
- Reports: KindOfReport in ('Paper', 'Email')
  ![S2_bewijs_video_duration.png](../S2/Screenshots/Reports_KindOfReport.jpg)
- Reports: Report_Send_date > Report_Creation_Date
  ![S2_bewijs_video_duration.png](../S2/Screenshots/Reports_DATE_Creation_Send.jpg)
- Measurements: Measurement_End_Date > Measurement_Start_Date
  ![S2_bewijs_video_duration.png](../S2/Screenshots/Measurements_DATE_start_end.jpg)
- Measurement: Result > 0
  ![S2_bewijs_video_duration.png](../S2/Screenshots/Measurements_Result.jpg)


Security
---
    S1: 
- view 
![S1_view_ABCD.png](/D5_QUERY/S1/Screenshots/ViewS1.png)

![S1_view_ABCD_2.png](/D5_QUERY/S1/Screenshots/ViewS1_2.png)

    S2
- view
![S2_view_WXYZ.png](../S2/Screenshots/viewS2.jpg) 
![S2_view_WXYZ_DDL.png](../S2/Screenshots/viewS2.2.jpg)

- overzicht system privileges
![dict_tab_privs.png](../S2/Screenshots/privileges.jpg)

- S1: 
![S1_bewijs_syn_DML_DDL.png](../S1/)

- S2:
![S2_bewijs_insertKeyPresserved.png](../S2/Screenshots/Insert%20User.jpg)