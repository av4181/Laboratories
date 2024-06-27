TRUNCATE TABLE MEASUREMENTS;
TRUNCATE TABLE INSTRUMENTS;
TRUNCATE TABLE LAB_TECHNICIANS;
TRUNCATE TABLE SAMPLES;
TRUNCATE TABLE LABORATORIES;
TRUNCATE TABLE REPORTS;
TRUNCATE TABLE CAMPAIGNS;
TRUNCATE TABLE CONTACTS;
commit;

--laboratory S1 --
INSERT INTO Laboratories
(LABORATORY_NAME, COMPANY, LABORATORY_STREET, LABORATORY_STREET_NUMBER, LABORATORY_DESCRIPTION, LABORATORY_LOCATION)
VALUES ('VITO', 'Overheid', 'BOERETANG', 200, 'Labo voor grondstalen', 'Mol');
INSERT INTO Laboratories
(LABORATORY_NAME, COMPANY, LABORATORY_STREET, LABORATORY_STREET_NUMBER, LABORATORY_DESCRIPTION, LABORATORY_LOCATION)
VALUES ('UZA', 'Overheid', 'DRIE EIKENSTRAAT', 655, 'Chemie', 'Edegem');
INSERT INTO Laboratories
(LABORATORY_NAME, COMPANY, LABORATORY_STREET, LABORATORY_STREET_NUMBER, LABORATORY_DESCRIPTION, LABORATORY_LOCATION)
VALUES ('AZ Voorkempen', 'Overheid', 'OUDE LIERSEBAAN', 4, 'Microbiologie', 'Malle');
INSERT INTO Laboratories
(LABORATORY_NAME, COMPANY, LABORATORY_STREET, LABORATORY_STREET_NUMBER, LABORATORY_DESCRIPTION, LABORATORY_LOCATION)
VALUES ('Klinisch labo AZM', 'Overheid', 'FLORENT PAUWELSLEI', 1, 'Toxicologie', 'Deurne');
INSERT INTO Laboratories
(LABORATORY_NAME, COMPANY, LABORATORY_STREET, LABORATORY_STREET_NUMBER, LABORATORY_DESCRIPTION, LABORATORY_LOCATION)
VALUES ('Insituut voor tropische geneeskunde', 'Overheid', 'KRONENBURGSTRAAT', 433, 'Toxicologie', 'Deurne');

--labratories S2--
INSERT INTO Laboratories
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_LOCATION)
VALUES ('VITO Bodem', 'Overheid', 'Boereveld', 190, 'Labo voor grondstalen', 'Mol');
INSERT INTO Laboratories
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_LOCATION)
VALUES ('UZA Ziekenhuis', 'Overheid', 'Groenplaats', 156, 'Chemie', 'Antwerpen');
INSERT INTO Laboratories
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_LOCATION)
VALUES ('AZ Voorkempen Beerse', 'Overheid', 'OUDEBAAN', 4, 'Microbiologie', 'Beerse');
INSERT INTO Laboratories
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_LOCATION)
VALUES ('BASF Zwijnaarde', 'INEOS', 'Technologie-Park', 101, 'Toxicologie', 'Zwijnaarde');
INSERT INTO Laboratories
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_LOCATION)
VALUES ('Medisch Centrum Herentals', 'CMA', 'oudstrijderslaan', 199, 'Medisch', 'Herentals');


-- Instrument S1--
INSERT INTO INSTRUMENTS(Instrument_Description, Instrument_Name, Instrument_Cost)
VALUES ('Chromotography', 'GE Multiskan', '€500');
INSERT INTO INSTRUMENTS(Instrument_Description, Instrument_Name, Instrument_Cost)
VALUES ('Spectroscopy', 'Siemens Spectro', '€1100');
INSERT INTO INSTRUMENTS(Instrument_Description, Instrument_Name, Instrument_Cost)
VALUES ('Calory', 'ABB XL', '€105');
INSERT INTO INSTRUMENTS(Instrument_Description, Instrument_Name, Instrument_Cost)
VALUES ('Luminometer', 'Lumac', '€805');
INSERT INTO INSTRUMENTS(Instrument_Description, Instrument_Name, Instrument_Cost)
VALUES ('pH Measurement', 'Hach Lange', '€125');

-- Sample S1 --
INSERT INTO Samples(Sample_Description, Sample_Status, Sampling_Date, Samplepoint, Sample_Type, Product)
VALUES ('Tank B600', 'SHIPPED', '20/10/22 10:35:00', 'QT501010', 'inline', 'benzene');
INSERT INTO Samples(Sample_Description, Sample_Status, Sampling_Date, Samplepoint, Sample_Type, Product)
VALUES ('Water Treatment', 'CANCELLED', '03/01/23 10:35:00', 'QI10005', 'probe', 'water');
INSERT INTO Samples(Sample_Description, Sample_Status, Sampling_Date, Samplepoint, Sample_Type, Product)
VALUES ('Extruder', 'FINAL', '08/01/20 08:15:11', 'Q123456', 'QA', 'polymer');
INSERT INTO Samples(Sample_Description, Sample_Status, Sampling_Date, Samplepoint, Sample_Type, Product)
VALUES ('Flare', 'FINAL', '30/03/24 09:54:00', 'QIC65124', 'Emissions', 'VOC');
INSERT INTO Samples(Sample_Description, Sample_Status, Sampling_Date, Samplepoint, Sample_Type, Product)
VALUES ('Ship Unloading', 'SHIPPED', '01/12/22 15:26:01', 'Q789456', 'Imports', 'nafta');

-- Lab_Technicians S1--
INSERT INTO Lab_Technicians
(Laboratory_ID, Supervisor_ID, First_Name, Last_Name, Gender, Function, Function_Start_Date, Function_End_Date)
VALUES ((SELECT Laboratory_ID FROM Laboratories WHERE Laboratory_Name = 'VITO'),
        NULL,
        'Bruno', 'Willems', 'M', 'Manager', TO_DATE('29/09/05', 'DD/MM/YYYY'), NULL);

INSERT INTO Lab_Technicians
(Laboratory_ID, Supervisor_ID, First_Name, Last_Name, Gender, Function, Function_Start_Date, Function_End_Date)
VALUES ((SELECT Laboratory_ID FROM Laboratories WHERE Laboratory_Name = 'UZA'),
        NULL,
        'An', 'Jacobs', 'V', 'Technician', TO_DATE('15/01/2010', 'DD/MM/YYYY'), NULL);

INSERT INTO Lab_Technicians
(Laboratory_ID, Supervisor_ID, First_Name, Last_Name, Gender, Function, Function_Start_Date, Function_End_Date)
VALUES ((SELECT Laboratory_ID FROM Laboratories WHERE Laboratory_Name = 'UZA'),
        NULL,
        'Katrien', 'Wauters', 'V', 'Technician', TO_DATE('10/07/1978', 'DD/MM/YYYY'), NULL);

INSERT INTO Lab_Technicians
(Laboratory_ID, Supervisor_ID, First_Name, Last_Name, Gender, Function, Function_Start_Date, Function_End_Date)
VALUES ((SELECT Laboratory_ID FROM Laboratories WHERE Laboratory_Name = 'Klinisch labo AZM'),
        NULL, 'Tom', 'Peeters', 'M', 'Shiftleader', TO_DATE('01/11/1982', 'DD/MM/YYYY'), NULL);

INSERT INTO Lab_Technicians
(Laboratory_ID, Supervisor_ID, First_Name, Last_Name, Gender, Function, Function_Start_Date, Function_End_Date)
VALUES ((SELECT Laboratory_ID FROM Laboratories WHERE Laboratory_Name = 'VITO'),
        NULL,
        'Inge', 'De Smet', 'V', 'Technician', TO_DATE('01/02/1999', 'DD/MM/YYYY'), NULL);

UPDATE Lab_Technicians
SET Supervisor_ID = (SELECT TECHNICIAN_ID FROM Lab_Technicians WHERE FIRST_NAME = 'Tom' and LAST_NAME = 'Peeters')
WHERE First_Name = 'An'
  AND LAST_NAME = 'Jacobs';

UPDATE Lab_Technicians
SET Supervisor_ID = (SELECT TECHNICIAN_ID FROM Lab_Technicians WHERE FIRST_NAME = 'Tom' and LAST_NAME = 'Peeters')
WHERE First_Name = 'Katrien'
  AND LAST_NAME = 'Wauters';

UPDATE Lab_Technicians
SET Supervisor_ID = (SELECT TECHNICIAN_ID FROM Lab_Technicians WHERE FIRST_NAME = 'Bruno' and LAST_NAME = 'Willems')
WHERE First_Name = 'Tom'
  AND LAST_NAME = 'Peeters';

UPDATE Lab_Technicians
SET Supervisor_ID = (SELECT TECHNICIAN_ID FROM Lab_Technicians WHERE FIRST_NAME = 'Tom' and LAST_NAME = 'Peeters')
WHERE First_Name = 'Inge'
  AND LAST_NAME = 'De Smet';

--Contacts S2--
insert into CONTACTS (first_name, last_name, middle_name, email)
values ('An', 'Jacobs', null, 'An.Jacobs@uza.com');
insert into CONTACTS (first_name, last_name, middle_name, email)
values ('Katrien', 'Wauters', null, 'Katrien.wouters@AZ.com');
insert into CONTACTS (first_name, last_name, middle_name, email)
values ('Tom', 'Peeters', null, 'Tom.peeters@Vito.com');
insert into CONTACTS (first_name, last_name, middle_name, email)
values ('Bruno', 'Willems', null, 'Bruno.Willems@AZM.com');
insert into CONTACTS (first_name, last_name, middle_name, email)
values ('Andreas', 'van Loon', null, 'Andreas.van.loon@outlook.com');
insert into CONTACTS (first_name, last_name, middle_name, email)
values ('Stef', 'Henderickx', null, 'Stef.henderickx@outlook.com');

--campaigns S2--
INSERT INTO CAMPAIGNS (CAMPAIGN_CREATION_DATE, CAMPAIGN_START_DATE, CAMPAIGN_END_DATE, CAMPAIGN_DESCRIPTION,
                       CAMPAIGN_PURPOSE, CAMPAIGN_REQUESTER_ID, CAMPAIGN_STATUS)
values ('31/01/24 8:00:00', '01/02/24 10:00:00', '01/02/24 16:00:00', 'Gewicht en pH meting van patient staal',
        'Uitsluiting van mogelheden behandeling',
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Andreas' and LAST_NAME = 'van Loon'), 'Completed');
INSERT INTO CAMPAIGNS (CAMPAIGN_CREATION_DATE, CAMPAIGN_START_DATE, CAMPAIGN_END_DATE, CAMPAIGN_DESCRIPTION,
                       CAMPAIGN_PURPOSE, CAMPAIGN_REQUESTER_ID, CAMPAIGN_STATUS)
values ('05/08/22 08:00:00', '05/08/22 16:22:05', '06/08/22 09:20:00',
        'Bepaling hoeveel micro organisme gegroeid zijn op lactaat voedingsbodems',
        'Effect van lactaat op bacteriële groei bepalen',
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Stef' and LAST_NAME = 'Henderickx'), 'Completed');
INSERT INTO CAMPAIGNS (CAMPAIGN_CREATION_DATE, CAMPAIGN_START_DATE, CAMPAIGN_END_DATE, CAMPAIGN_DESCRIPTION,
                       CAMPAIGN_PURPOSE, CAMPAIGN_REQUESTER_ID, CAMPAIGN_STATUS)
values ('01/11/17 10:00:00', '11/11/17 10:00:00', '11/11/17 17:00:00',
        'Energie absorbantie bepalen van heide bodemstaal, SP:56443', 'Schokbestendigheid bodem bepalen',
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Andreas' and LAST_NAME = 'van Loon'), 'Completed');
INSERT INTO CAMPAIGNS (CAMPAIGN_CREATION_DATE, CAMPAIGN_START_DATE, CAMPAIGN_END_DATE, CAMPAIGN_DESCRIPTION,
                       CAMPAIGN_PURPOSE, CAMPAIGN_REQUESTER_ID, CAMPAIGN_STATUS)
values ('29/08/20 8:00:00', '30/08/20 11:16:15', null, 'Bepaling vet- en spiergehalte van patient',
        'Vet- en spierbepaling',
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Andreas' and LAST_NAME = 'van Loon'), 'Active');
INSERT INTO CAMPAIGNS (CAMPAIGN_CREATION_DATE, CAMPAIGN_START_DATE, CAMPAIGN_END_DATE, CAMPAIGN_DESCRIPTION,
                       CAMPAIGN_PURPOSE, CAMPAIGN_REQUESTER_ID, CAMPAIGN_STATUS)
values ('16/04/24 8:00:00', null, null, 'Concentratie bepaling product Q5681', 'Zuiverheidsbepaling',
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Andreas' and LAST_NAME = 'van Loon'), 'Initial');

-- reports S2 --
--reports
INSERT INTO REPORTS
(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE, KINDOFREPORT)
values ((select CAMPAIGN_ID
         from CAMPAIGNS
                  inner join CONTACTS on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = CONTACTS.PERSON_ID
         where CAMPAIGN_START_DATE = '01/02/24 10:00:00'
           AND CONTACTS.FIRST_NAME = 'Andreas'
           AND CONTACTS.LAST_NAME = 'van Loon'), '01/02/24 12:05:00',
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Tom' and LAST_NAME = 'Peeters'),
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Andreas' and LAST_NAME = 'van Loon'), '01/02/24 12:10:02',
        'Paper');

INSERT INTO REPORTS
(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE, KINDOFREPORT)
values ((select CAMPAIGN_ID
         from CAMPAIGNS
                  inner join CONTACTS on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = CONTACTS.PERSON_ID
         where CAMPAIGN_START_DATE = '01/02/24 10:00:00'
           AND CONTACTS.FIRST_NAME = 'Andreas'
           AND CONTACTS.LAST_NAME = 'van Loon'), '01/02/24 15:50:00',
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'An' and LAST_NAME = 'Jacobs'),
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Andreas' and LAST_NAME = 'van Loon'), '01/02/24 15:55:00',
        'Paper');

INSERT INTO REPORTS
(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE, KINDOFREPORT)
values ((select CAMPAIGN_ID
         from CAMPAIGNS
                  inner join CONTACTS on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = CONTACTS.PERSON_ID
         where CAMPAIGN_START_DATE = '05/08/22 16:22:05'
           AND CONTACTS.FIRST_NAME = 'Stef'
           AND CONTACTS.LAST_NAME = 'Henderickx'), '06/08/22 09:10:00',
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Tom' and LAST_NAME = 'Peeters'),
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Stef' and LAST_NAME = 'Henderickx'), '06/08/22 09:15:00',
        'Email');

INSERT INTO REPORTS
(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE, KINDOFREPORT)
values ((select CAMPAIGN_ID
         from CAMPAIGNS
                  inner join CONTACTS on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = CONTACTS.PERSON_ID
         where CAMPAIGN_START_DATE = '11/11/17 10:00:00'
           AND CONTACTS.FIRST_NAME = 'Andreas'
           AND CONTACTS.LAST_NAME = 'van Loon'), '11/11/17 16:50:00',
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Bruno' and LAST_NAME = 'Willems'),
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Andreas' and LAST_NAME = 'van Loon'), '11/11/17 16:55:00',
        'Paper');

INSERT INTO REPORTS
(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE, KINDOFREPORT)
values ((select CAMPAIGN_ID
         from CAMPAIGNS
                  inner join CONTACTS on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = CONTACTS.PERSON_ID
         where CAMPAIGN_START_DATE = '30/08/20 11:16:15'
           AND CONTACTS.FIRST_NAME = 'Andreas'
           AND CONTACTS.LAST_NAME = 'van Loon'), '30/08/20 11:25:00',
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'An' and LAST_NAME = 'Jacobs'),
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Andreas' and LAST_NAME = 'van Loon'), '30/08/20 11:30:00',
        'Email');

-- Measurement S1 --
INSERT INTO Measurements
(Sample_ID, Instrument_ID, Technician_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Water Treatment'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'pH Measurement'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'An' and LAST_NAME = 'Jacobs'),
        '01/02/22 10:00:00',
        '01/02/22 12:00:00',
        500,
        'ppm',
        95);

INSERT INTO Measurements
(Sample_ID, Instrument_ID, Technician_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Water Treatment'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'pH Measurement'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'Tom' and LAST_NAME = 'Peeters'),
        '05/03/23 16:00:00',
        '06/03/23 09:00:00',
        7.1,
        'pH',
        70);

INSERT INTO Measurements
(Sample_ID, Instrument_ID, Technician_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Water Treatment'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'Spectroscopy'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'An' and LAST_NAME = 'Jacobs'),
        '01/10/19 15:00:00',
        '02/10/19 16:00:00',
        20,
        'wt-%',
        205);

INSERT INTO Measurements
(Sample_ID, Instrument_ID, Technician_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Flare'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'Calory'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'Katrien' and LAST_NAME = 'Wauters'),
        '11/11/15 10:00:00',
        '11/11/15 13:00:00',
        40000,
        'kJ/kg',
        95);

INSERT INTO MeasurementS
(Sample_ID, Instrument_ID, Technician_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Extruder'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'Spectroscopy'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'Katrien' and LAST_NAME = 'Wauters'),
        '30/08/21 11:00:00',
        '01/09/21 13:00:00',
        10,
        'wt-%',
        205);

--measurements s2--

INSERT INTO Measurements
(REPORT_ID, SAMPLE_ID, TECHNICIAN_ID, INSTRUMENT_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit,
 Measurement_Cost)
VALUES ((select report_ID
         from REPORTS
                  inner join CAMPAIGNS on REPORTS.CAMPAIGN_ID = CAMPAIGNS.CAMPAIGN_ID
                  inner join CONTACTS receveir on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = receveir.PERSON_ID
                  inner join CONTACTS sender on REPORTS.REPORT_SENDER_ID = sender.PERSON_ID
         where CAMPAIGNS.CAMPAIGN_ID = (select CAMPAIGN_ID
                                        from CAMPAIGNS
                                                 inner join CONTACTS on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = CONTACTS.PERSON_ID
                                        where CAMPAIGN_START_DATE = '01/02/24 10:00:00'
                                          AND CONTACTS.FIRST_NAME = 'Andreas'
                                          AND CONTACTS.LAST_NAME = 'van Loon')
           AND REPORT_SENDER_ID = (select PERSON_ID from CONTACTS where FIRST_NAME = 'Tom' and LAST_NAME = 'Peeters')
           AND REPORT_CREATION_DATE = '01/02/24 12:05:00'),
        (SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Water Treatment'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'Tom' and LAST_NAME = 'Peeters'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'pH Measurement'), '01/02/24 10:00:00',
        '01/02/24 12:04:02', 10, 'g', 123);
INSERT INTO Measurements
(REPORT_ID, SAMPLE_ID, TECHNICIAN_ID, INSTRUMENT_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit,
 Measurement_Cost)
VALUES ((select report_ID
         from REPORTS
                  inner join CAMPAIGNS on REPORTS.CAMPAIGN_ID = CAMPAIGNS.CAMPAIGN_ID
                  inner join CONTACTS receveir on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = receveir.PERSON_ID
                  inner join CONTACTS sender on REPORTS.REPORT_SENDER_ID = sender.PERSON_ID
         where CAMPAIGNS.CAMPAIGN_ID = (select CAMPAIGN_ID
                                        from CAMPAIGNS
                                                 inner join CONTACTS on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = CONTACTS.PERSON_ID
                                        where CAMPAIGN_START_DATE = '05/08/22 16:22:05'
                                          AND CONTACTS.FIRST_NAME = 'Stef'
                                          AND CONTACTS.LAST_NAME = 'Henderickx')
           AND REPORT_SENDER_ID = (select PERSON_ID from CONTACTS where FIRST_NAME = 'Tom' and LAST_NAME = 'Peeters')
           AND REPORT_CREATION_DATE = '06/08/22 09:10:00'),
        (SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Flare'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'Katrien' and LAST_NAME = 'Wauters'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'Calory'), '05/08/22 16:22:05',
        '06/08/22 09:02:54', 21564, null, 150);

INSERT INTO Measurements
(REPORT_ID, SAMPLE_ID, TECHNICIAN_ID, INSTRUMENT_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit,
 Measurement_Cost)
VALUES ((select report_ID
         from REPORTS
                  inner join CAMPAIGNS on REPORTS.CAMPAIGN_ID = CAMPAIGNS.CAMPAIGN_ID
                  inner join CONTACTS receveir on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = receveir.PERSON_ID
                  inner join CONTACTS sender on REPORTS.REPORT_SENDER_ID = sender.PERSON_ID
         where CAMPAIGNS.CAMPAIGN_ID = (select CAMPAIGN_ID
                                        from CAMPAIGNS
                                                 inner join CONTACTS on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = CONTACTS.PERSON_ID
                                        where CAMPAIGN_START_DATE = '01/02/24 10:00:00'
                                          AND CONTACTS.FIRST_NAME = 'Andreas'
                                          AND CONTACTS.LAST_NAME = 'van Loon')
           AND REPORT_SENDER_ID = (select PERSON_ID from CONTACTS where FIRST_NAME = 'An' and LAST_NAME = 'Jacobs')
           AND REPORT_CREATION_DATE = '01/02/24 15:50:00'),
        (SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Water Treatment'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'An' and LAST_NAME = 'Jacobs'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'pH Measurement'),
        '01/02/24 15:05:15',
        '01/02/24 15:45:48', 3, 'pH', 40);

INSERT INTO Measurements
(REPORT_ID, SAMPLE_ID, TECHNICIAN_ID, INSTRUMENT_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit,
 Measurement_Cost)
VALUES ((select report_ID
         from REPORTS
                  inner join CAMPAIGNS on REPORTS.CAMPAIGN_ID = CAMPAIGNS.CAMPAIGN_ID
                  inner join CONTACTS receveir on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = receveir.PERSON_ID
                  inner join CONTACTS sender on REPORTS.REPORT_SENDER_ID = sender.PERSON_ID
         where CAMPAIGNS.CAMPAIGN_ID = (select CAMPAIGN_ID
                                        from CAMPAIGNS
                                                 inner join CONTACTS on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = CONTACTS.PERSON_ID
                                        where CAMPAIGN_START_DATE = '11/11/17 10:00:00'
                                          AND CONTACTS.FIRST_NAME = 'Andreas'
                                          AND CONTACTS.LAST_NAME = 'van Loon')
           AND REPORT_SENDER_ID = (select PERSON_ID from CONTACTS where FIRST_NAME = 'Bruno' and LAST_NAME = 'Willems')
           AND REPORT_CREATION_DATE = '11/11/17 16:50:00'),
        (SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Extruder'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'Katrien' and LAST_NAME = 'Wauters'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'Spectroscopy'),
        '11/11/17 10:00:12',
        '11/11/17 13:22:19', 4000, 'kJ/kg', 189);

INSERT INTO Measurements
(REPORT_ID, SAMPLE_ID, TECHNICIAN_ID, INSTRUMENT_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit,
 Measurement_Cost)
VALUES (null, (SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Water Treatment'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'An' and LAST_NAME = 'Jacobs'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'Spectroscopy'),
        '30/08/20 11:16:15', null, null,
        '%', 200);

INSERT INTO Measurements
(REPORT_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost, SAMPLE_ID, TECHNICIAN_ID,
 INSTRUMENT_ID)
VALUES ((select report_ID
         from REPORTS
                  inner join CAMPAIGNS on REPORTS.CAMPAIGN_ID = CAMPAIGNS.CAMPAIGN_ID
                  inner join CONTACTS receveir on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = receveir.PERSON_ID
                  inner join CONTACTS sender on REPORTS.REPORT_SENDER_ID = sender.PERSON_ID
         where CAMPAIGNS.CAMPAIGN_ID = (select CAMPAIGN_ID
                                        from CAMPAIGNS
                                                 inner join CONTACTS on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = CONTACTS.PERSON_ID
                                        where CAMPAIGN_START_DATE = '30/08/20 11:16:15'
                                          AND CONTACTS.FIRST_NAME = 'Andreas'
                                          AND CONTACTS.LAST_NAME = 'van Loon')
           AND REPORT_SENDER_ID = (select PERSON_ID from CONTACTS where FIRST_NAME = 'An' and LAST_NAME = 'Jacobs')
           AND REPORT_CREATION_DATE = '30/08/20 11:25:00'), '30/08/20 11:16:15',
        '30/08/20 11:20:08', 47, '%', 200,
        (SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Water Treatment'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'An' and LAST_NAME = 'Jacobs'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'Spectroscopy'));

commit;







