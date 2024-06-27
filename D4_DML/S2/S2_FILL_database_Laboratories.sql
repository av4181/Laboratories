TRUNCATE TABLE MEASUREMENTS;
TRUNCATE TABLE LABORATORY;
TRUNCATE TABLE REPORTS;
TRUNCATE TABLE CAMPAIGNS;
TRUNCATE TABLE CONTACTS;

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
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_LOCATION)
VALUES ('VITO Bodem', 'Overheid', 'Boereveld', 190, 'Labo voor grondstalen', 'Mol');
INSERT INTO Laboratory
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_LOCATION)
VALUES ('UZA Ziekenhuis', 'Overheid', 'Groenplaats', 156, 'Chemie', 'Antwerpen');
INSERT INTO Laboratory
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_LOCATION)
VALUES ('AZ Voorkempen Beerse', 'Overheid', 'OUDEBAAN', 4, 'Microbiologie', 'Beerse');
INSERT INTO Laboratory
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_LOCATION)
VALUES ('BASF Zwijnaarde', 'INEOS', 'Technologie-Park', 101, 'Toxicologie', 'Zwijnaarde');
INSERT INTO Laboratory
(Laboratory_Name, Company, Laboratory_Street, LABORATORY_STREET_NUMBER, Laboratory_Description, LABORATORY_LOCATION)
VALUES ('Medisch Centrum Herentals', 'CMA', 'oudstrijderslaan', 199, 'Medisch', 'Herentals');


--campaigns
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

--measurements
INSERT INTO Measurements
(Laboratory_ID, REPORT_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((select LABORATORY_ID from LABORATORY where LABORATORY_NAME = 'AZ Voorkempen Beerse'),
        (select report_ID
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
           AND REPORT_CREATION_DATE = '01/02/24 12:05:00'), '01/02/24 10:00:00',
        '01/02/24 12:04:02', 10, 'g', 123);
INSERT INTO Measurements
(Laboratory_ID, REPORT_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((select LABORATORY_ID from LABORATORY where LABORATORY_NAME = 'AZ Voorkempen Beerse'),
        (select report_ID
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
           AND REPORT_CREATION_DATE = '06/08/22 09:10:00'), '05/08/22 16:22:05',
        '06/08/22 09:02:54', 21564, null, 150);

INSERT INTO Measurements
(Laboratory_ID, REPORT_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((select LABORATORY_ID from LABORATORY where LABORATORY_NAME = 'UZA Ziekenhuis'),
        (select report_ID
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
           AND REPORT_CREATION_DATE = '01/02/24 15:50:00'), '01/02/24 15:05:15',
        '01/02/24 15:45:48', 3, 'pH', 40);

INSERT INTO Measurements
(Laboratory_ID, REPORT_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((select LABORATORY_ID from LABORATORY where LABORATORY_NAME = 'VITO Bodem'),
        (select report_ID
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
           AND REPORT_CREATION_DATE = '11/11/17 16:50:00'), '11/11/17 10:00:12',
        '11/11/17 13:22:19', 4000, 'kJ/kg', 189);

INSERT INTO Measurements
(Laboratory_ID, REPORT_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((select LABORATORY_ID from LABORATORY where LABORATORY_NAME = 'UZA Ziekenhuis'), null, '30/08/20 11:16:15', null, null,
        '%', 200);

INSERT INTO Measurements
(Laboratory_ID, REPORT_ID, Measurement_Start_Date, Measurement_End_Date, Result, Unit, Measurement_Cost)
VALUES ((select LABORATORY_ID from LABORATORY where LABORATORY_NAME = 'UZA Ziekenhuis'),
        (select report_ID
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
        '30/08/20 11:20:08', 47, '%', 200);

commit;




