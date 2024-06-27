--Contacts
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

--Laboratory
INSERT INTO Laboratory
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_CITY)
VALUES ('VITO', 'Overheid', 'BOERETANG', 200, 'Labo voor grondstalen', 'Mol');
INSERT INTO Laboratory
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_CITY)
VALUES ('UZA', 'Overheid', 'DRIE EIKENSTRAAT', 655, 'Chemie', 'Edegem');
INSERT INTO Laboratory
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_CITY)
VALUES ('AZ Voorkempen', 'Overheid', 'OUDE LIERSEBAAN', 4, 'Microbiologie', 'Malle');
INSERT INTO Laboratory
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_CITY)
VALUES ('Klinisch labo AZM', 'Overheid', 'FLORENT PAUWELSLEI', 1, 'Toxicologie', 'Deurne');
INSERT INTO Laboratory
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_CITY)
VALUES ('Insituut voor tropische geneeskunde', 'Overheid', 'KRONENBURGSTRAAT', 433, 'Toxicologie', 'Deurne');

--measurement
INSERT INTO Measurements
(Laboratory_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((select LABORATORY_ID from LABORATORY where LABORATORY.LABORATORY_NAME = ?/*3*/), '01/02/24 10:00:00',
        '01/02/24 12:04:02', 154, 'g', 123);
INSERT INTO Measurements
(Laboratory_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((select LABORATORY_ID from LABORATORY where LABORATORY.LABORATORY_NAME = ? /*3*/), '05/08/22 16:22:05',
        '06/08/22 09:02:54', 21564, null, 150);
INSERT INTO Measurements
(Laboratory_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((select LABORATORY_ID from LABORATORY where LABORATORY.LABORATORY_NAME = ? /*2*/), '01/02/24 15:05:15',
        '01/02/24 15:45:48', 3, 'pH', 40);
INSERT INTO Measurements
(Laboratory_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((select LABORATORY_ID from LABORATORY where LABORATORY.LABORATORY_NAME = ? /*1*/), '11/11/17 10:00:12',
        '11/11/17 13:22:19', 4000, 'kJ/kg', 189);
INSERT INTO Measurements
(Laboratory_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((select LABORATORY_ID from LABORATORY where LABORATORY.LABORATORY_NAME = ? /*2*/), '30/08/20 11:16:15', null,
        null, '%', 200);
INSERT INTO Measurements
(Laboratory_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((select LABORATORY_ID from LABORATORY where LABORATORY.LABORATORY_NAME = ? /*2*/), '30/08/20 11:16:15',
        '30/08/20 11:20:08', 47, '%', 200);

--campaigns
INSERT INTO CAMPAIGNS (CAMPAIGN_CREATION_DATE, CAMPAIGN_START_DATE, CAMPAIGN_END_DATE, CAMPAIGN_DESCRIPTION,
                       CAMPAIGN_PURPOSE, CAMPAIGN_REQUESTER_ID)
values ('31/01/24 8:00:00', '01/02/24 10:00:00', '01/02/24 16:00:00', 'Gewicht en pH meting van patient staal',
        'Uitsluiting van mogelheden behandeling', (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*6*/);
INSERT INTO CAMPAIGNS (CAMPAIGN_CREATION_DATE, CAMPAIGN_START_DATE, CAMPAIGN_END_DATE, CAMPAIGN_DESCRIPTION,
                       CAMPAIGN_PURPOSE, CAMPAIGN_REQUESTER_ID)
values ('05/08/22 08:00:00', '05/08/22 16:22:05', '06/08/22 09:20:00',
        'Bepaling hoeveel micro organisme gegroeid zijn op lactaat voedingsbodems',
        'Effect van lactaat op bacteriële groei bepalen', (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*7*/);
INSERT INTO CAMPAIGNS (CAMPAIGN_CREATION_DATE, CAMPAIGN_START_DATE, CAMPAIGN_END_DATE, CAMPAIGN_DESCRIPTION,
                       CAMPAIGN_PURPOSE, CAMPAIGN_REQUESTER_ID)
values ('01/11/17 10:00:00', '11/11/17 10:00:00', '11/11/17 17:00:00',
        'Energie absorbantie bepalen van heide bodemstaal, SP:56443', 'Schokbestendigheid bodem bepalen',
        (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*6*/);
INSERT INTO CAMPAIGNS (CAMPAIGN_CREATION_DATE, CAMPAIGN_START_DATE, CAMPAIGN_END_DATE, CAMPAIGN_DESCRIPTION,
                       CAMPAIGN_PURPOSE, CAMPAIGN_REQUESTER_ID)
values ('29/08/20 8:00:00', '30/08/20 11:16:15', null, 'Bepaling vet- en spiergehalte van patient',
        'Vet- en spierbepaling', (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*6*/);
INSERT INTO CAMPAIGNS (CAMPAIGN_CREATION_DATE, CAMPAIGN_START_DATE, CAMPAIGN_END_DATE, CAMPAIGN_DESCRIPTION,
                       CAMPAIGN_PURPOSE, CAMPAIGN_REQUESTER_ID)
values ('16/04/24 8:00:00', null, null, 'Concentratie bepaling product Q5681', 'Zuiverheidsbepaling',
        (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*7*/);

--reports
INSERT INTO REPORTS
(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE, PRINTED_REPORT)
values ((select CAMPAIGN_ID from CAMPAIGNS where CAMPAIGN_ID = ?)/*1*/, '01/02/24 12:05:00',
        (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*5*/, (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*6*/,
        '01/02/24 12:10:02', 'N');
INSERT INTO REPORTS
(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE, PRINTED_REPORT)
values ((select CAMPAIGN_ID from CAMPAIGNS where CAMPAIGN_ID = ?)/*1*/, '01/02/24 15:50:00',
        (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*1*/, (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*6*/,
        '01/02/24 15:55:00', 'N');
INSERT INTO REPORTS
(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE, PRINTED_REPORT)
values ((select CAMPAIGN_ID from CAMPAIGNS where CAMPAIGN_ID = ?)/*2*/, '06/08/22 09:10:00',
        (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*3*/, (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*7*/,
        '06/08/22 09:15:00', 'N');
INSERT INTO REPORTS
(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE, PRINTED_REPORT)
values ((select CAMPAIGN_ID from CAMPAIGNS where CAMPAIGN_ID = ?)/*3*/, '11/11/17 16:50:00',
        (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*4*/, (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*6*/,
        '11/11/17 16:55:00', 'N');
INSERT INTO REPORTS
(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE, PRINTED_REPORT)
values ((select CAMPAIGN_ID from CAMPAIGNS where CAMPAIGN_ID = ?)/*4*/, '30/08/20 11:25:00',
        (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*1*/, (select PERSON_ID from CONTACTS where PERSON_ID = ?)/*6*/,
        '30/08/20 11:30:00', 'Y');


select report_ID
from REPORTS
         inner join CAMPAIGNS on REPORTS.CAMPAIGN_ID = CAMPAIGNS.CAMPAIGN_ID
         inner join CONTACTS receveir on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = receveir.PERSON_ID
         inner join CONTACTS sender on REPORTS.REPORT_SENDER_ID = sender.PERSON_ID
where CAMPAIGNS.CAMPAIGN_ID = (select CAMPAIGN_ID
                               from CAMPAIGNS
                                        inner join CONTACTS on CAMPAIGNS.CAMPAIGN_REQUESTER_ID = CONTACTS.PERSON_ID
                               where CAMPAIGN_START_DATE = null
                                 AND CONTACTS.FIRST_NAME = null
                                 AND CONTACTS.LAST_NAME = null)
  AND REPORT_SENDER_ID = (select PERSON_ID from CONTACTS where FIRST_NAME = null and LAST_NAME = null)
  AND REPORT_CREATION_DATE = null;


select *
from CAMPAIGNS





