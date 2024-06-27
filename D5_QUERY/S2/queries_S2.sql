SELECT 'S2 W - Laboratories' AS table_name, (SELECT COUNT(*) FROM Laboratory) AS table_count
FROM dual
UNION
SELECT 'S2 X - Measurements', (SELECT COUNT(*) FROM MEASUREMENTS)
FROM dual
UNION
SELECT 'S2 Y - Reports', (SELECT COUNT(*) FROM REPORTS)
FROM dual
UNION
SELECT 'S2 Z - Campaigns', (SELECT COUNT(*) FROM CAMPAIGNS)
FROM dual
UNION
SELECT 'S2 - Contacs', (SELECT COUNT(*) FROM CONTACTS)
FROM dual;

--2 diep

select *
from MEASUREMENTS
         inner join REPORTS on
    REPORTS.REPORT_ID = MEASUREMENTS.REPORT_ID
         inner join CAMPAIGNS on
    REPORTS.CAMPAIGN_ID = CAMPAIGNs.CAMPAIGN_ID;

select *
from LABORATORY
         inner join PROJECT.MEASUREMENTS M on LABORATORY.LABORATORY_ID = M.LABORATORY_ID
         inner join PROJECT.REPORTS R on M.REPORT_ID = R.REPORT_ID
         inner join CONTACTS c on R.REPORT_RECEIVER_ID = c.PERSON_ID
;

--prove constraints:

--Campaigns: Campaign_Status in ( Campaign_Start_Date >= Campaign_Creation_Date )
INSERT INTO CAMPAIGNS(campaign_creation_date, campaign_start_date, campaign_end_date, campaign_description,
                      campaign_purpose, campaign_requester_id, CAMPAIGN_STATUS)
values ('20/04/2024 23:12:05', '20/04/2024 23:12:00', '20/04/2024 00:01:01', 'description', 'purpose', 1, 'status')
;

-- Campaigns: Campaign_End_Date > Campaign_Start_Date
INSERT INTO CAMPAIGNS (CAMPAIGN_CREATION_DATE, CAMPAIGN_START_DATE, CAMPAIGN_END_DATE, CAMPAIGN_DESCRIPTION,
                       CAMPAIGN_PURPOSE, CAMPAIGN_REQUESTER_ID)
values ('16/04/24 8:00:00', '16/04/24 10:00:00', '16/04/24 9:00:00', 'Concentratie bepaling product Q5681',
        'Zuiverheidsbepaling', 6);
;

-- Campaigns:  Campaign_Start_Date >= Campaign_Creation_Date
INSERT INTO CAMPAIGNS (CAMPAIGN_CREATION_DATE, CAMPAIGN_START_DATE, CAMPAIGN_END_DATE, CAMPAIGN_DESCRIPTION,
                       CAMPAIGN_PURPOSE, CAMPAIGN_REQUESTER_ID)
values ('16/04/24 8:00:01', '16/04/24 8:00:00', '16/04/24 9:00:00', 'Concentratie bepaling product Q5681',
        'Zuiverheidsbepaling', 6);
;

-- Reports: KindOfReport in ('Email', 'Paper')
INSERT INTO REPORTS
(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE, KINDOFREPORT)
values (1, '30/08/20 11:25:00', 1, 1, '30/08/20 11:30:00', 'y')
;

-- Reports: Report_Send_date > Report_Creation_Date
INSERT INTO REPORTS
(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE, KINDOFREPORT)
values (1, '30/08/20 11:30:01', 1, 1, '30/08/20 11:30:00', 'Paper')
;

-- Measurements: Measurement_End_Date > Measurement_Start_Date
INSERT INTO Measurements
(Laboratory_ID, REPORT_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES (1,
        1, '30/08/20 11:30:15',
        '30/08/20 11:20:08', 47, '%', 200);
;

-- Measurement: Result > 0
INSERT INTO Measurements
(Laboratory_ID, REPORT_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES (1,
        1, '30/08/20 11:12:15',
        '30/08/20 11:20:08', -2, '%', 200);
;