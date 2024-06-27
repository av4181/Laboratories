create or replace PACKAGE BODY PKG_SAMENS2_M4_LABORATORIES
AS
    --EMPTY TABLES--
    PROCEDURE empty_tables_S2
    AS
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE MEASUREMENTS';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE REPORTS';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE CAMPAIGNS';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE CONTACTS';
        EXECUTE IMMEDIATE 'ALTER TABLE LAB_TECHNICIANS DISABLE CONSTRAINT LABORATORY_LAB_TECHNICIANS_FK'; -- moet meenemen vanwege FK's
        EXECUTE IMMEDIATE 'TRUNCATE TABLE LABORATORIES';


        EXECUTE IMMEDIATE 'ALTER TABLE MEASUREMENTS MODIFY MEASUREMENT_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE REPORTS MODIFY REPORT_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE CAMPAIGNS MODIFY CAMPAIGN_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE CONTACTS MODIFY PERSON_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE LABORATORIES MODIFY LABORATORY_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';

    END empty_tables_S2;

    --LOOKUP FUNCTIONS--
    FUNCTION lookup_person(p_person_first_name IN CONTACTS.FIRST_NAME%TYPE,
                           p_person_last_name IN CONTACTS.LAST_NAME%TYPE)
        return CONTACTS.PERSON_ID%TYPE
    AS
        v_person CONTACTS.PERSON_ID%TYPE;
    BEGIN
        SELECT PERSON_ID
        INTO v_person
        FROM CONTACTS
        WHERE FIRST_NAME = p_person_first_name
          AND LAST_NAME = p_person_last_name;

        RETURN v_person;
    EXCEPTION
        WHEN NO_DATA_FOUND then
            return null;
    END lookup_person;

    FUNCTION lookup_campaign(p_startdate IN CAMPAIGNS.CAMPAIGN_START_DATE%TYPE,
                             p_requesterID IN CAMPAIGNS.CAMPAIGN_REQUESTER_ID%TYPE)
        RETURN CAMPAIGNS.CAMPAIGN_ID%TYPE
    AS
        v_campaignnumber CAMPAIGNS.CAMPAIGN_ID%TYPE;
    BEGIN
        SELECT CAMPAIGN_ID
        INTO v_campaignnumber
        FROM CAMPAIGNS
        WHERE CAMPAIGN_START_DATE = p_startdate
          AND CAMPAIGN_REQUESTER_ID = p_requesterID;

        return v_campaignnumber;
    EXCEPTION
        WHEN NO_DATA_FOUND then
            return null;
    end lookup_campaign;

    FUNCTION lookup_report(p_campaign_start IN CAMPAIGNS.CAMPAIGN_START_DATE%TYPE,
                           p_requester_firstname IN CONTACTS.FIRST_NAME%TYPE,
                           p_requester_lastname IN CONTACTS.LAST_NAME%TYPE,
                           p_report_creation_date in REPORTS.REPORT_CREATION_DATE%TYPE,
                           p_sender_firstname IN CONTACTS.FIRST_NAME%TYPE,
                           p_sender_lastname IN CONTACTS.LAST_NAME%TYPE
    )
        RETURN REPORTS.REPORT_ID%TYPE
    AS
        v_requester_id CONTACTS.PERSON_ID%TYPE    := lookup_person(p_requester_firstname, p_requester_lastname);
        v_sender_id    CONTACTS.PERSON_ID%TYPE    := lookup_person(p_sender_firstname, p_sender_lastname);
        v_campaign_id  CAMPAIGNS.CAMPAIGN_ID%TYPE := lookup_campaign(p_campaign_start, v_requester_id);
        v_report_id    REPORTS.REPORT_ID%TYPE     := null;
    BEGIN
        SELECT REPORT_ID
        INTO v_report_id
        FROM REPORTS
        WHERE REPORT_SENDER_ID = v_sender_id
          AND CAMPAIGN_ID = v_campaign_id
          AND REPORT_CREATION_DATE = p_report_creation_date;

        return v_report_id;
    EXCEPTION
        WHEN NO_DATA_FOUND then
            return null;
    END lookup_report;


    --ADD PROCEDURES--

    PROCEDURE add_laboratory(
        p_laboratory_name IN LABORATORIES.LABORATORY_NAME%TYPE,
        p_company IN LABORATORIES.COMPANY%TYPE,
        p_laboratory_street IN LABORATORIES.LABORATORY_STREET%TYPE,
        p_laboratory_street_number IN LABORATORIES.LABORATORY_STREET_NUMBER%TYPE,
        p_laboratory_description IN LABORATORIES.LABORATORY_DESCRIPTION%TYPE,
        p_laboratory_city IN LABORATORIES.LABORATORY_LOCATION%TYPE
    )
    AS
    BEGIN
        INSERT INTO LABORATORIES(LABORATORY_NAME, LABORATORY_DESCRIPTION, LABORATORY_STREET_NUMBER, LABORATORY_STREET,
                                 LABORATORY_LOCATION, COMPANY)
        VALUES (p_laboratory_name, p_laboratory_description, p_laboratory_street_number, p_laboratory_street,
                p_laboratory_city, p_company);
    END add_laboratory;

    PROCEDURE add_contacts(
        p_first_name IN CONTACTS.FIRST_NAME%TYPE,
        p_last_name IN CONTACTS.LAST_NAME%TYPE,
        p_middle_name IN CONTACTS.MIDDLE_NAME%TYPE,
        p_email IN CONTACTS.EMAIL%TYPE
    )
    AS
    BEGIN
        insert into CONTACTS(first_name, last_name, middle_name, email)
        VALUES (p_first_name, p_last_name, p_middle_name, p_email);
    END add_contacts;

    PROCEDURE add_campaign(
        p_campaign_creation_date IN CAMPAIGNS.CAMPAIGN_CREATION_DATE%TYPE,
        p_campaign_start_date IN CAMPAIGNS.CAMPAIGN_START_DATE%TYPE,
        p_campaign_end_date IN CAMPAIGNS.CAMPAIGN_END_DATE%TYPE,
        p_description IN CAMPAIGNS.CAMPAIGN_DESCRIPTION%TYPE,
        p_purpose IN CAMPAIGNS.CAMPAIGN_PURPOSE%TYPE,
        p_requester_firstname IN CONTACTS.FIRST_NAME%TYPE,
        p_requester_lastname IN CONTACTS.LAST_NAME%TYPE,
        p_campaign_status IN CAMPAIGNS.CAMPAIGN_STATUS%TYPE)
    AS
        v_requester CONTACTS.PERSON_ID%TYPE := lookup_person(p_requester_firstname, p_requester_lastname);
    BEGIN
        INSERT INTO CAMPAIGNS(campaign_creation_date, campaign_start_date, campaign_end_date, campaign_description,
                              campaign_purpose, campaign_requester_id, CAMPAIGN_STATUS)
        VALUES ( p_campaign_creation_date, p_campaign_start_date, p_campaign_end_date, p_description, p_purpose
               , v_requester
               , p_campaign_status);
    END add_campaign;

    PROCEDURE add_report(p_campaign_start IN CAMPAIGNS.CAMPAIGN_START_DATE%TYPE,
                         p_requester_firstname IN CONTACTS.FIRST_NAME%TYPE,
                         p_requester_lastname IN CONTACTS.LAST_NAME%TYPE,
                         p_report_creation_date IN REPORTS.REPORT_CREATION_DATE%TYPE,
                         p_sender_firstname IN CONTACTS.FIRST_NAME%TYPE,
                         p_sender_lastname IN CONTACTS.LAST_NAME%TYPE,
                         p_report_send_date IN REPORTS.REPORT_SEND_DATE%TYPE,
                         p_kindofreport IN REPORTS.KINDOFREPORT%TYPE)
    AS
        v_requester CONTACTS.PERSON_ID%TYPE    := lookup_person(p_requester_firstname, p_requester_lastname);
        v_sender    CONTACTS.PERSON_ID%TYPE    := lookup_person(p_sender_firstname, p_sender_lastname);
        v_campaign  CAMPAIGNS.CAMPAIGN_ID%TYPE := lookup_campaign(p_campaign_start, v_requester);
    BEGIN
        INSERT INTO REPORTS(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE,
                            KINDOFREPORT)
        VALUES (v_campaign, p_report_creation_date, v_sender, v_requester, p_report_send_date, p_kindofreport);
    END add_report;

    PROCEDURE add_measurement(p_campaign_start IN CAMPAIGNS.CAMPAIGN_START_DATE%TYPE,
                              p_requester_firstname IN CONTACTS.FIRST_NAME%TYPE,
                              p_requester_lastname IN CONTACTS.LAST_NAME%TYPE,
                              p_report_creation_date in REPORTS.REPORT_CREATION_DATE%TYPE,
                              p_sender_firstname IN CONTACTS.FIRST_NAME%TYPE,
                              p_sender_lastname IN CONTACTS.LAST_NAME%TYPE,
                              p_sample_description IN SAMPLES.SAMPLE_DESCRIPTION%TYPE,
                              p_technician_first_name IN LAB_TECHNICIANS.FIRST_NAME%TYPE,
                              p_technician_last_name IN LAB_TECHNICIANS.LAST_NAME%TYPE,
                              p_instrument_description in INSTRUMENTS.INSTRUMENT_description%TYPE,
                              p_measurement_start_date IN MEASUREMENTS.MEASUREMENT_START_DATE%TYPE,
                              p_measurement_end_date IN MEASUREMENTS.MEASUREMENT_END_DATE%TYPE,
                              p_result IN MEASUREMENTS.RESULT%TYPE,
                              p_unit IN MEASUREMENTS.UNIT%TYPE,
                              p_measurement_cost IN MEASUREMENTS.MEASUREMENT_COST%TYPE
    )
    AS
        v_report     REPORTS.REPORT_ID%TYPE             := lookup_report(p_campaign_start, p_requester_firstname,
                                                                         p_requester_lastname,
                                                                         p_report_creation_date, p_sender_firstname,
                                                                         p_sender_lastname);
        v_sample     SAMPLES.SAMPLE_ID%TYPE             := PKG_SAMENS1_M4_LABORATORIES.lookup_sample(p_sample_description);
        v_instrument INSTRUMENTs.INSTRUMENT_ID%TYPE     := PKG_SAMENS1_M4_LABORATORIES.lookup_instrument(p_instrument_description);
        v_technician LAB_TECHNICIANS.TECHNICIAN_ID%TYPE := PKG_SAMENS1_M4_LABORATORIES.lookup_lab_technician(
                p_technician_first_name,
                p_technician_last_name);
    BEGIN
        INSERT INTO MEASUREMENTS(REPORT_ID, SAMPLE_ID, INSTRUMENT_ID, TECHNICIAN_ID, MEASUREMENT_START_DATE,
                                 MEASUREMENT_END_DATE, RESULT, UNIT,
                                 MEASUREMENT_COST)
        VALUES (v_report, v_sample, v_instrument, v_technician, p_measurement_start_date, p_measurement_end_date,
                p_result, p_unit, p_measurement_cost);
    END add_measurement;

    --SAMEN functies

    PROCEDURE add_laboratory_samen
    AS
    BEGIN
        add_laboratory('VITO', 'Overheid', 'BOERETANG', 200, 'Labo voor grondstalen',
                       'Mol');
        add_laboratory('UZA', 'Overheid', 'DRIE EIKENSTRAAT', 655, 'Chemie', 'Edegem');
        add_laboratory('AZ Voorkempen', 'Overheid', 'OUDE LIERSEBAAN', 4,
                       'Microbiologie', 'Malle');
        add_laboratory('Klinisch labo AZM', 'Overheid', 'FLORENT PAUWELSLEI', 1,
                       'Toxicologie', 'Deurne');
        add_laboratory('Insituut voor tropische geneeskunde', 'Overheid',
                       'KRONENBURGSTRAAT', 433, 'Toxicologie', 'Deurne');
        DBMS_OUTPUT.PUT_LINE('Laboratories restored');
    END add_laboratory_samen;



    PROCEDURE
        bewijs_Milestone_M4_S2
    AS
    BEGIN

        add_contacts('An', 'Jacobs', null, 'An.Jacobs@UZA.com');
        add_contacts('Katrien', 'Wauters', null, 'Katrien.wouters@AZ.com');
        add_contacts('Tom', 'Peeters', null, 'Tom.peeters@Vito.com');
        add_contacts('Bruno', 'Willems', null, 'Bruno.Willems@AZM.com');
        add_contacts('Andreas', 'van Loon', null, 'Andreas.van.loon@outlook.com');
        add_contacts('Stef', 'Henderickx', null, 'Stef.henderickx@outlook.com');

        add_laboratory('VITO', 'Overheid', 'BOERETANG', 200, 'Labo voor grondstalen', 'Mol');
        add_laboratory('UZA', 'Overheid', 'DRIE EIKENSTRAAT', 655, 'Chemie', 'Edegem');
        add_laboratory('AZ Voorkempen', 'Overheid', 'OUDE LIERSEBAAN', 4, 'Microbiologie', 'Malle');
        add_laboratory('Klinisch labo AZM', 'Overheid', 'FLORENT PAUWELSLEI', 1, 'Toxicologie', 'Deurne');
        add_laboratory('Insituut voor tropische geneeskunde', 'Overheid', 'KRONENBURGSTRAAT', 433, 'Toxicologie',
                       'Deurne');

        EXECUTE IMMEDIATE 'ALTER TABLE LAB_TECHNICIANS ENABLE CONSTRAINT LABORATORY_LAB_TECHNICIANS_FK';

        add_campaign('31/01/24 8:00:00', '01/02/24 10:00:00', '01/02/24 16:00:00',
                     'Gewicht en pH meting van patient staal', 'Uitsluiting van mogelheden behandeling', 'Andreas',
                     'van Loon', 'Comleted');
        add_campaign('05/08/22 08:00:00', '05/08/22 16:22:05', '06/08/22 09:20:00',
                     'Bepaling hoeveel micro organisme gegroeid zijn op lactaat voedingsbodems',
                     'Effect van lactaat op bacteriële groei bepalen', 'Stef', 'Henderickx', 'Completed');
        add_campaign('01/11/17 10:00:00', '11/11/17 10:00:00', '11/11/17 17:00:00',
                     'Energie absorbantie bepalen van heide bodemstaal, SP:56443',
                     'Schokbestendigheid bodem bepalen',
                     'Andreas', 'van Loon', 'Completed');
        add_campaign('29/08/20 8:00:00', '30/08/20 11:16:15', null, 'Bepaling vet- en spiergehalte van patient',
                     'Vet- en spierbepaling', 'Andreas', 'van Loon', 'Active');
        add_campaign('16/04/24 8:00:00', null, null, 'Concentratie bepaling product Q5681', 'Zuiverheidsbepaling',
                     'Andreas', 'van Loon', 'Initial');

        add_report('01/02/24 10:00:00', 'Andreas', 'van Loon', '01/02/24 12:05:00', 'Tom', 'Peeters',
                   '01/02/24 12:10:02', 'Paper');
        add_report('01/02/24 10:00:00', 'Andreas', 'van Loon', '01/02/24 15:50:00', 'An', 'Jacobs',
                   '01/02/24 15:55:00',
                   'Paper');
        add_report('05/08/22 16:22:05', 'Stef', 'Henderickx', '06/08/22 09:10:00', 'Tom', 'Peeters',
                   '06/08/22 09:15:00', 'Email');
        add_report('11/11/17 10:00:00', 'Andreas', 'van Loon', '11/11/17 16:50:00', 'Bruno', 'Willems',
                   '11/11/17 16:55:00', 'Paper');
        add_report('30/08/20 11:16:15', 'Andreas', 'van Loon', '30/08/20 11:25:00', 'An', 'Jacobs',
                   '30/08/20 11:30:00',
                   'Email');

        add_measurement('01/02/24 10:00:00', 'Andreas', 'van Loon', '01/02/24 12:05:00', 'Tom', 'Peeters',
                        'Water Treatment', 'Tom', 'Peeters', 'pH Measurement',
                        '01/02/24 10:00:00', '01/02/24 12:04:02', 10, 'g', 123);
        add_measurement('05/08/22 16:22:05', 'Stef', 'Henderickx', '06/08/22 09:10:00', 'Tom', 'Peeters',
                        'Flare', 'Katrien', 'Wauters', 'Calory',
                        '05/08/22 16:22:05', '06/08/22 09:02:54', 21564, null, 150);
        add_measurement('01/02/24 10:00:00', 'Andreas', 'van Loon', '01/02/24 15:50:00', 'An', 'Jacobs',
                        'Water Treatment', 'An', 'Jacobs', 'pH Measurement',
                        '01/02/24 15:05:15', '01/02/24 15:45:48', 3, 'pH', 40);
        add_measurement('11/11/17 10:00:00', 'Andreas', 'van Loon', '11/11/17 16:50:00', 'Bruno', 'Willems',
                        'Extruder', 'Katrien', 'Wauters', 'Spectroscopy',
                        '11/11/17 10:00:12', '11/11/17 13:22:19', 4000, 'kJ/kg', 189);
        add_measurement(null, null, null, null, null, null, 'Water Treatment', 'An', 'Jacobs', 'Spectroscopy',
                        '30/08/20 11:16:15',
                        null, null, '%', 200);
        add_measurement('30/08/20 11:16:15', 'Andreas', 'van Loon', '30/08/20 11:25:00', 'An', 'Jacobs',
                        'Water Treatment', 'An', 'Jacobs', 'Spectroscopy',
                        TO_TIMESTAMP('30/08/20 11:16:15', 'DD/MM/YYYY HH24:MI:SS'), '30/08/20 11:20:08', 47, '%',
                        200);

    END bewijs_Milestone_M4_S2;


END PKG_SAMENS2_M4_LABORATORIES;
/

