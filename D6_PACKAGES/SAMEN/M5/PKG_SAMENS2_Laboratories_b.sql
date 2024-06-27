create OR REPLACE PACKAGE BODY PKG_SAMENS2_M5_LABORATORIES
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
            v_sample     SAMPLES.SAMPLE_ID%TYPE             := PKG_SAMENS1_M5_LABORATORIES.lookup_sample(p_sample_description);
            v_instrument INSTRUMENTs.INSTRUMENT_ID%TYPE     := PKG_SAMENS1_M5_LABORATORIES.lookup_instrument(p_instrument_description);
            v_technician LAB_TECHNICIANS.TECHNICIAN_ID%TYPE := PKG_SAMENS1_M5_LABORATORIES.lookup_lab_technician(
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

---------------------------------------------------------------------------------- M5
    --Milestone 5--

--random functies--
    FUNCTION random_number(p_min NUMERIC, p_max NUMERIC)
        RETURN NUMERIC
    AS
        v_number NUMERIC := TRUNC(DBMS_RANDOM.VALUE(p_min, p_max));
    BEGIN
        return v_number;
    END random_number;

    FUNCTION random_date(p_startdate DATE, p_enddate DATE)
        return DATE
    AS
        v_difference INTEGER := (p_enddate - p_startdate);
        v_addition   NUMBER  := random_number(1, v_difference);
    BEGIN
        return (p_startdate + v_addition);
    END random_date;

    FUNCTION random_decimal_number(p_min NUMERIC, p_max NUMERIC, p_round NUMERIC)
        RETURN FLOAT
    AS
        v_decimal_number FLOAT := ROUND(DBMS_RANDOM.VALUE(p_min, p_max), p_round);
    BEGIN
        return v_decimal_number;
    END random_decimal_number;

    FUNCTION random_lab_name
        RETURN LABORATORIES.LABORATORY_NAME%TYPE
    AS
        TYPE t_tab_names IS TABLE OF LABORATORIES.LABORATORY_NAME%TYPE;
        t_name       t_tab_names := t_tab_names('Quantum Dynamics Lab', 'Bioinformatics Research Center',
                                                'Advanced Materials Lab', 'Neural Networks Lab',
                                                'Genetic Engineering Research Lab', 'Astrophysics Research Center',
                                                'Nanotechnology Development Lab', 'Environmental Science Lab',
                                                'Cognitive Science Lab', 'Data Analysis and Statistics Lab',
                                                'Robotics and Artificial Intelligence Lab', 'Molecular Biology Lab',
                                                'Plasma Physics Lab', 'Organic Chemistry Lab',
                                                'High Energy Physics Lab', 'Marine Biology Research Lab',
                                                'Human-Computer Interaction Lab', 'Geology and Earth Science Lab',
                                                'Aerospace Engineering Lab', 'Microbiology and Immunology Lab',
                                                'Cryptography and Network Security Lab', 'Quantum Computing Lab',
                                                'Cellular Biology Research Lab', 'Theoretical Physics Lab',
                                                'Biomechanics Lab', 'Climate Change Study Center',
                                                'Forensic Science Lab', 'Computational Linguistics Lab',
                                                'Paleontology Research Lab', 'Space Exploration Lab',
                                                'Biophysics Research Lab', 'Optics and Photonics Lab',
                                                'Particle Physics Lab', 'Cybersecurity Research Lab',
                                                'Evolutionary Biology Lab', 'Energy Systems Lab',
                                                'Structural Engineering Lab', 'Neuroscience Research Lab',
                                                'Genomics and Proteomics Lab',
                                                'Meteorology and Atmospheric Science Lab', 'Machine Learning Lab',
                                                'Environmental Engineering Lab', 'Biomedical Engineering Lab',
                                                'Food Science and Technology Lab', 'Quantum Mechanics Lab',
                                                'Astrophotography Lab', 'Biochemistry and Molecular Biology Lab',
                                                'Geophysics Research Lab', 'Nuclear Physics Lab',
                                                'Planetary Science Lab', 'Theoretical Computer Science Lab',
                                                'Zoology Research Lab', 'Botany and Plant Science Lab',
                                                'Fluid Dynamics Lab', 'Solid State Physics Lab',
                                                'Thermodynamics Lab',
                                                'Electromagnetic Theory Lab', 'Analytical Chemistry Lab',
                                                'Physical Chemistry Lab', 'Inorganic Chemistry Lab',
                                                'Organic Synthesis Lab', 'Medicinal Chemistry Lab',
                                                'Polymer Science Lab', 'Spectroscopy Lab', 'Crystallography Lab',
                                                'Quantum Chemistry Lab', 'Surface Chemistry Lab',
                                                'Environmental Chemistry Lab', 'Industrial Chemistry Lab',
                                                'Agricultural Chemistry Lab', 'Food Chemistry Lab',
                                                'Forensic Chemistry Lab', 'Geochemistry Lab', 'Green Chemistry Lab',
                                                'Nuclear Chemistry Lab', 'Petrochemistry Lab', 'Pharmacology Lab',
                                                'Photochemistry Lab', 'Phytochemistry Lab', 'Stereochemistry Lab',
                                                'Supramolecular Chemistry Lab', 'Synthetic Chemistry Lab',
                                                'Theoretical Chemistry Lab', 'Thermochemistry Lab',
                                                'Atmospheric Chemistry Lab', 'Chemical Biology Lab',
                                                'Chemical Engineering Lab', 'Chemical Physics Lab',
                                                'Computational Chemistry Lab', 'Electrochemistry Lab',
                                                'Femtochemistry Lab', 'Flow Chemistry Lab', 'Geochemistry Lab',
                                                'Immunochemistry Lab', 'Marine Chemistry Lab',
                                                'Mathematical Chemistry Lab', 'Mechanochemistry Lab',
                                                'Medicinal Chemistry Lab', 'Molecular Biology Lab',
                                                'Nanochemistry Lab');
        v_lab_picker NUMERIC     := random_number(1, t_name.COUNT);
    BEGIN
        return t_name(v_lab_picker);
    END;

    FUNCTION random_street
        RETURN LABORATORIES.LABORATORY_STREET%TYPE
    AS
        TYPE type_tab_streetNames IS TABLE OF LABORATORIES.LABORATORY_STREET%TYPE;
        t_street        type_tab_streetNames := type_tab_streetNames('Abtenstraat', 'Averbodestraat',
                                                                     'Berendrechtsluis',
                                                                     'Berendrechtweg',
                                                                     'Biestraatje', 'Binnenpad', 'Bokspane',
                                                                     'Bonkelaarstraat',
                                                                     'Bosdreef',
                                                                     'Boterbekeweg', 'Breedsteert', 'Buitenmolenweg',
                                                                     'Burgemeester Verhulstplein', 'Cecilianenstraat',
                                                                     'Derdeweg',
                                                                     'Dominicanenstraat', 'Dopheidestraat',
                                                                     'Dorpsbeekstraat',
                                                                     'Emelinusstraat', 'Franciscanenstraat',
                                                                     'Frederik-Hendrikstraat',
                                                                     'Gansrijdersstraat', 'Gillis Damaesstraat',
                                                                     'Goudhoekstraat',
                                                                     'Hagelberg', 'Heesterbos', 'Heiblokken',
                                                                     'Hoefbladstraat',
                                                                     'Keyserstraatje', 'Kleine Bredestraat',
                                                                     'Kluisdijk', 'Kommershoek',
                                                                     'Konijnendreef', 'Krommeweg', 'Kruisbos',
                                                                     'Magershoek',
                                                                     'Middelburgstraat', 'Monnikenhofstraat',
                                                                     'Neerhoefstraat',
                                                                     'Norbertijnenstraat', 'Oostmolengeest',
                                                                     'Oude Papenstraat',
                                                                     'Oudedijkweg', 'Pastoor Verlindenstraat',
                                                                     'Piep-in-‘t-Riet',
                                                                     'Pootersstraat', 'Potpolderweg', 'Predikherenbos',
                                                                     'Prelatenstraat',
                                                                     'Raapakker', 'Reigersbosdreef', 'Rietbank');
        v_street_picker NUMERIC              := random_number(1, t_street.COUNT);
    BEGIN
        return t_street(v_street_picker);
    END;


    FUNCTION random_location
        RETURN LABORATORIES.LABORATORY_LOCATION%TYPE
    AS
        TYPE t_tab_Locations IS TABLE OF LABORATORIES.LABORATORY_LOCATION%TYPE;
        t_locations       t_tab_Locations := t_tab_Locations('Antwerpen', 'Mechelen', 'Turnhout', 'Heist-op-den-Berg',
                                                             'Brasschaat',
                                                             'Geel', 'Hoboken', 'Schoten', 'Lier', 'Mol', 'Kapellen',
                                                             'Herentals',
                                                             'Brecht', 'Mortsel', 'Willebroek', 'Westerlo', 'Edegem',
                                                             'Nijlen',
                                                             'Zoersel', 'Schilde', 'Hasselt', 'Genk', 'Beringen',
                                                             'Sint-Truiden',
                                                             'Lommel', 'Tongeren', 'Maaseik', 'Diepenbeek',
                                                             'Heusden-Zolder',
                                                             'Peer', 'Bilzen', 'Houthalen-Helchteren', 'Lanaken',
                                                             'Opglabbeek',
                                                             'Zonhoven', 'Neerpelt', 'Maasmechelen', 'Leopoldsburg',
                                                             'Herstal',
                                                             'Dilsen-Stokkem', 'Gent', 'Aalst', 'Sint-Niklaas',
                                                             'Dendermonde',
                                                             'Oudenaarde', 'Lokeren', 'Eeklo', 'Zele', 'Deinze',
                                                             'Geraardsbergen');
        v_location_picker NUMERIC         := random_number(1, t_locations.COUNT);
    BEGIN
        return t_locations(v_location_picker);
    END;

    FUNCTION random_company
        return LABORATORIES.COMPANY%TYPE
    AS
        TYPE t_tab_companies IS TABLE OF LABORATORIES.COMPANY%TYPE;
        t_companies      t_tab_companies := t_tab_companies('LAMBO Laboratories', 'Saybolt Belgium',
                                                            'Alcon Laboratories Belgium', 'AgomAb Therapeutics',
                                                            'atbtherapeutics', 'Biocartis', 'Innovad Laboratories',
                                                            'Ablynx',
                                                            'TiGenix', 'MaSTherCell', 'Bone Therapeutics',
                                                            'Delphi Genetics',
                                                            'Catalent Pharma', 'Sanofi', 'Takeda', 'ArgenX',
                                                            'V-Bio Ventures',
                                                            'Advent France Biotechnology', 'AstraZeneca',
                                                            'Financière Spin Off Lux.', 'BASF', 'VITO',
                                                            'UZA');
        v_company_picker NUMERIC         := random_number(1, t_companies.COUNT);
    BEGIN
        return t_companies(v_company_picker);
    END;

    FUNCTION timestamp_diff(a timestamp, b timestamp)
        RETURN NUMBER IS
    BEGIN
        RETURN EXTRACT(day
                       from (a - b)) * 24 * 60 * 60 +
               EXTRACT(hour from (a - b)) * 60 * 60 +
               EXTRACT(minute from (a - b)) * 60 +
               EXTRACT(second from (a - b));
    END;

    FUNCTION random_timestamp(p_startdate IN TIMESTAMP, p_enddate IN TIMESTAMP)
        return TIMESTAMP
    AS
        v_seconds   NUMERIC := random_number(0, timestamp_diff(p_enddate, p_startdate));
        v_timestamp TIMESTAMP;
    BEGIN

        v_timestamp := (p_startdate + NUMTODSINTERVAL(v_seconds, 'SECOND'));
        return v_timestamp;
    END random_timestamp;

    FUNCTION random_unit
        return MEASUREMENTS.UNIT%TYPE
    AS
        TYPE t_tab_unit IS TABLE OF MEASUREMENTS.UNIT%TYPE;
        t_unit        t_tab_unit := t_tab_unit('mol', 'M', 'mol/L', 'mol/kg', 'N', 'ppm', 'ppb', 'ppt', 'g', 'mg', 'µg',
                                               'ng',
                                               'pg', 'fg', 'Da', 'kDa', 'amu', 'eV', 'J', 'cal', 'kcal', 'IU', 'U',
                                               'U/mg',
                                               'kcat/KM', 'kcat', 'KM', 'pH', 'Osm/L', 'Osm/kg', 'atm', 'torr', 'mmHg',
                                               'Pa',
                                               'bar', 'mbar', 'psi', '°C', '°F', 'K', 'nm', 'µm', 'mm', 'cm', 'm', 'km',
                                               'Å',
                                               'L', 'mL', 'µL', 'nL', 'pL', 'fL', 'M', 'mM', 'µM', 'nM', 'pM', 'fM',
                                               'mEq',
                                               'meq/L', 'eq', 'eq/L', 'dpm', 'Ci', 'Bq', 'Gy', 'Sv', 'kat');
        v_unit_picker NUMERIC    := random_number(1, t_unit.COUNT);
    BEGIN
        return t_unit(v_unit_picker);
    END random_unit;

    FUNCTION random_report_kind
        return REPORTS.KINDOFREPORT%TYPE
    AS
        TYPE t_tab_reports IS VARRAY(2) OF REPORTS.KINDOFREPORT%TYPE;
        t_kind        t_tab_reports := t_tab_reports('Paper', 'Email');
        v_kind_picker NUMERIC       := random_number(1, t_kind.COUNT);
    BEGIN
        return t_kind(v_kind_picker);
    END random_report_kind;

    FUNCTION random_purpose
        RETURN CAMPAIGNS.CAMPAIGN_PURPOSE%TYPE
    AS
        TYPE t_tab_purpose IS TABLE OF CAMPAIGNS.CAMPAIGN_PURPOSE%TYPE;
        t_purpose        t_tab_purpose := t_tab_purpose('Identify unknown substances', 'Test material strength',
                                                        'Analyze chemical reactions', 'Study cell structures',
                                                        'Detect pathogens in samples', 'Measure nutrient levels',
                                                        'Monitor environmental conditions',
                                                        'Validate new drug efficacy',
                                                        'Investigate genetic sequences', 'Examine tissue samples',
                                                        'Evaluate food safety', 'Assess water quality',
                                                        'Determine blood type',
                                                        'Check for genetic disorders', 'Confirm presence of metals',
                                                        'Research on new materials', 'Develop new medications',
                                                        'Inspect product quality', 'Explore microbial cultures',
                                                        'Study effects of radiation', 'Test soil fertility',
                                                        'Analyze forensic evidence', 'Investigate disease outbreaks',
                                                        'Monitor air pollution', 'Validate sterilization methods',
                                                        'Examine plant diseases', 'Research cancer treatments',
                                                        'Test vaccine effectiveness', 'Study protein structures',
                                                        'Analyze metabolic pathways');
        v_purpose_picker NUMERIC       := random_number(1, t_purpose.COUNT);
    BEGIN
        return t_purpose(v_purpose_picker);
    END random_purpose;

--procedures M5--
    PROCEDURE add_multiple_laboratories(p_row_amount IN NUMERIC)
    AS
        TYPE t_tab_labs IS TABLE OF LABORATORIES.LABORATORY_ID%TYPE INDEX BY PLS_INTEGER;
        t_original_amount_labs t_tab_labs;
        r_laboraties           LABORATORIES%rowtype;
        v_counter              NUMERIC := p_row_amount;
        v_starttimestamp       TIMESTAMP;
    BEGIN
        v_starttimestamp := SYSTIMESTAMP;

        SELECT LABORATORY_ID BULK COLLECT
        INTO t_original_amount_labs
        from LABORATORIES;

        while v_counter > 0
            LOOP
                r_laboraties.LABORATORY_NAME := random_lab_name();
                r_laboraties.LABORATORY_DESCRIPTION := null;
                r_laboraties.LABORATORY_STREET_NUMBER := random_number(1, 300);
                r_laboraties.LABORATORY_STREET := random_street();
                r_laboraties.LABORATORY_LOCATION := random_location();
                r_laboraties.COMPANY := random_company();
                insert into LABORATORIES (LABORATORY_NAME, LABORATORY_DESCRIPTION, LABORATORY_STREET_NUMBER,
                                          LABORATORY_STREET, LABORATORY_LOCATION, COMPANY)
                values (r_laboraties.LABORATORY_NAME, r_laboraties.LABORATORY_DESCRIPTION,
                        r_laboraties.LABORATORY_STREET_NUMBER, r_laboraties.LABORATORY_STREET,
                        r_laboraties.LABORATORY_LOCATION, r_laboraties.COMPANY);
                v_counter := v_counter - 1;
            END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                             'add_multiple_laboratories with parameter input: ' || p_row_amount || ' generated ' ||
                             (p_row_amount) || ' lines. The generation time for this procedure was ' ||
                             timestamp_diff(SYSTIMESTAMP, v_starttimestamp) || ' seconds.' || u'\000D\000A' ||
                             'original amount: ' || t_original_amount_labs.COUNT || ' Current amout: ' ||
                             (t_original_amount_labs.COUNT + (p_row_amount)) || '.');
    END add_multiple_laboratories;

    PROCEDURE add_multiple_campaigns(p_row_amount IN NUMERIC)
    AS
        TYPE t_tab_campaigns IS TABLE OF CAMPAIGNS.CAMPAIGN_ID%TYPE INDEX BY PLS_INTEGER;
        t_original_amount_campaigns t_tab_campaigns;
        v_counter                   NUMERIC := p_row_amount;
        r_campaign                  CAMPAIGNS%rowtype;
        v_contact                   CONTACTS.PERSON_ID%TYPE;
        v_starttimestamp            TIMESTAMP;
    BEGIN
        v_starttimestamp := SYSTIMESTAMP;

        SELECT MAX(PERSON_ID)
        INTO v_contact
        FROM CONTACTS;

        SELECT campaign_ID BULK COLLECT
        INTO t_original_amount_campaigns
        from CAMPAIGNS;

        while v_counter > 0
            LOOP
                r_campaign.CAMPAIGN_CREATION_DATE :=
                        random_timestamp(SYSTIMESTAMP - NUMTODSINTERVAL(10, 'DAY'), SYSTIMESTAMP);
                r_campaign.CAMPAIGN_START_DATE :=
                        random_timestamp(r_campaign.CAMPAIGN_CREATION_DATE + NUMTODSINTERVAL(1, 'SECOND'),
                                         SYSTIMESTAMP);
                r_campaign.CAMPAIGN_END_DATE :=
                        random_timestamp(r_campaign.CAMPAIGN_START_DATE + NUMTODSINTERVAL(1, 'SECOND'), SYSTIMESTAMP);
                r_campaign.CAMPAIGN_PURPOSE := random_purpose();
                r_campaign.CAMPAIGN_DESCRIPTION := CONCAT('CAMPAIGN for ', r_campaign.CAMPAIGN_PURPOSE);
                r_campaign.CAMPAIGN_REQUESTER_ID := random_number(1, v_contact);
                if r_campaign.CAMPAIGN_END_DATE IS NOT NULL AND r_campaign.CAMPAIGN_START_DATE IS NOT NULL
                THEN
                    r_campaign.CAMPAIGN_STATUS := 'Completed';
                ELSE
                    IF r_campaign.CAMPAIGN_END_DATE IS NULL AND r_campaign.CAMPAIGN_START_DATE IS NOT NULL
                    THEN
                        r_campaign.CAMPAIGN_STATUS := 'Active';
                    ELSE
                        r_campaign.CAMPAIGN_STATUS := 'Initial';
                    END IF;
                END IF;

                INSERT INTO CAMPAIGNS (CAMPAIGN_CREATION_DATE, CAMPAIGN_START_DATE, CAMPAIGN_END_DATE,
                                       CAMPAIGN_DESCRIPTION, CAMPAIGN_PURPOSE, CAMPAIGN_REQUESTER_ID)
                VALUES (r_campaign.CAMPAIGN_CREATION_DATE, r_campaign.CAMPAIGN_START_DATE, r_campaign.CAMPAIGN_END_DATE,
                        r_campaign.CAMPAIGN_DESCRIPTION, r_campaign.CAMPAIGN_PURPOSE, r_campaign.CAMPAIGN_REQUESTER_ID);

                v_counter := v_counter - 1;
            END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                             'add_multiple_campaigns with parameter input: ' || p_row_amount || ' generated ' ||
                             (p_row_amount) || ' lines. The generation time for this procedure was ' ||
                             timestamp_diff(SYSTIMESTAMP, v_starttimestamp) || ' seconds.' || u'\000D\000A' ||
                             'original amount: ' || t_original_amount_campaigns.COUNT || ' Current amout: ' ||
                             (t_original_amount_campaigns.COUNT + (p_row_amount)) || '.');
    END add_multiple_campaigns;

    PROCEDURE add_multiple_reports(p_row_amount IN NUMERIC)
    AS
        TYPE t_tab_campaign IS TABLE OF CAMPAIGNS.CAMPAIGN_ID%TYPE;
        t_campaign                t_tab_campaign;
        TYPE t_tab_reports IS TABLE OF REPORTS.REPORT_ID%TYPE INDEX BY PLS_INTEGER;
        t_original_amount_reports t_tab_reports;
        V_counter                 NUMERIC;
        v_campaign                CAMPAIGNS.CAMPAIGN_ID%TYPE;
        r_report                  REPORTS%rowtype;
        v_contact                 CONTACTS.PERSON_ID%TYPE;
        v_starttimestamp          TIMESTAMP;
    BEGIN
        v_starttimestamp := SYSTIMESTAMP;
        SELECT CAMPAIGN_ID BULK COLLECT
        INTO t_campaign
        FROM CAMPAIGNS;

        SELECT MAX(CAMPAIGN_ID)
        INTO v_campaign
        from CAMPAIGNS;

        SELECT MAX(PERSON_ID)
        INTO v_contact
        FROM CONTACTS;

        SELECT REPORT_ID BULK COLLECT
        INTO t_original_amount_reports
        from REPORTS;

        v_counter := t_campaign.COUNT * p_row_amount;

        FOR i in 1..V_counter
            LOOP
                r_report.CAMPAIGN_ID := random_number(1, v_campaign);
                r_report.REPORT_CREATION_DATE :=
                        random_timestamp(SYSTIMESTAMP - NUMTODSINTERVAL(10, 'DAY'), SYSTIMESTAMP);
                r_report.REPORT_SENDER_ID := random_number(1, v_contact);
                r_report.REPORT_RECEIVER_ID := random_number(1, v_contact);
                r_report.REPORT_SEND_DATE :=
                        random_timestamp(r_report.REPORT_CREATION_DATE + NUMTODSINTERVAL(1, 'SECOND'), SYSTIMESTAMP);
                r_report.KINDOFREPORT := random_report_kind();

                INSERT INTO REPORTS(campaign_id, report_creation_date, report_sender_id, report_receiver_id,
                                    report_send_date, kindofreport)
                VALUES (r_report.CAMPAIGN_ID, r_report.REPORT_CREATION_DATE, r_report.REPORT_SENDER_ID,
                        r_report.REPORT_RECEIVER_ID, r_report.REPORT_SEND_DATE, r_report.KINDOFREPORT);
            END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                             'add_multiple_reports with parameter input: ' || p_row_amount || ' generated ' ||
                             (t_campaign.count * p_row_amount) ||
                             ' lines. The generation time for this procedure was ' ||
                             timestamp_diff(SYSTIMESTAMP, v_starttimestamp) || ' seconds.' ||
                             u'\000D\000A' ||
                             'original amount: ' || t_original_amount_reports.COUNT || ' Current amout: ' ||
                             (t_original_amount_reports.COUNT + (p_row_amount * t_campaign.COUNT)) || '.');
    END add_multiple_reports;

    PROCEDURE add_multiple_measurements(p_row_amount IN NUMERIC)
    AS
        TYPE t_tab_reports IS TABLE OF REPORTS.REPORT_ID%TYPE INDEX BY PLS_INTEGER;
        t_report               t_tab_reports;
        TYPE t_tab_meas IS TABLE OF MEASUREMENTS.MEASUREMENT_ID%TYPE INDEX BY PLS_INTEGER;
        t_original_amount_meas t_tab_meas;
        r_measurements         MEASUREMENTS%rowtype;
        v_reports              REPORTS.REPORT_ID%TYPE;
        v_counter              NUMERIC;
        v_starttimestamp       TIMESTAMP;
        v_max_samples          SAMPLES.SAMPLE_ID%TYPE;
        v_max_instruments      INSTRUMENTS.INSTRUMENT_ID%TYPE;
        v_max_technicians      LAB_TECHNICIANS.TECHNICIAN_ID%TYPE;

    BEGIN
        v_starttimestamp := SYSTIMESTAMP;

        SELECT MAX(REPORT_ID)
        INTO v_reports
        FROM REPORTS;

        SELECT REPORT_ID BULK COLLECT
        INTO t_report
        FROM REPORTS;

        SELECT MAX(SAMPLE_ID)
        INTO v_max_samples
        from SAMPLES;

        SELECT MAX(INSTRUMENT_ID)
        INTO v_max_instruments
        from INSTRUMENTS;

        SELECT MAX(TECHNICIAN_ID)
        INTO v_max_technicians
        from LAB_TECHNICIANS;

        SELECT MEASUREMENT_ID BULK COLLECT
        INTO t_original_amount_meas
        from MEASUREMENTS;

        v_counter := t_report.COUNT * p_row_amount;

        while v_counter > 0
            LOOP
                r_measurements.REPORT_ID := null;

                r_measurements.MEASUREMENT_START_DATE :=
                        random_timestamp(SYSTIMESTAMP - NUMTODSINTERVAL(10, 'DAY'),
                                         SYSTIMESTAMP);
                r_measurements.MEASUREMENT_END_DATE :=
                        random_timestamp(r_measurements.MEASUREMENT_START_DATE + NUMTODSINTERVAL(1, 'SECOND'),
                                         SYSTIMESTAMP);
                r_measurements.result := random_decimal_number(0.01, 1500, 2);
                r_measurements.unit := random_unit();
                r_measurements.MEASUREMENT_COST := random_decimal_number(1, 500, 2);
                r_measurements.SAMPLE_ID := random_number(1, v_max_samples);
                r_measurements.INSTRUMENT_ID := random_number(1, v_max_instruments);
                r_measurements.TECHNICIAN_ID := random_number(1, v_max_technicians);
                insert into MEASUREMENTS(report_id, SAMPLE_ID, INSTRUMENT_ID, TECHNICIAN_ID, measurement_start_date,
                                         measurement_end_date,
                                         result,
                                         unit, measurement_cost)
                values (r_measurements.REPORT_ID, r_measurements.SAMPLE_ID, r_measurements.INSTRUMENT_ID,
                        r_measurements.TECHNICIAN_ID,
                        r_measurements.MEASUREMENT_START_DATE,
                        r_measurements.MEASUREMENT_END_DATE, r_measurements.RESULT, r_measurements.UNIT,
                        r_measurements.MEASUREMENT_COST);
                v_counter := v_counter - 1;
            END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                             'add_multiple_measurement with parameter input: ' || p_row_amount || ' generated ' ||
                             (p_row_amount * t_report.COUNT) || ' lines. The generation time for this procedure was ' ||
                             timestamp_diff(SYSTIMESTAMP, v_starttimestamp) || ' seconds.' || u'\000D\000A' ||
                             'original amount: ' || t_original_amount_meas.COUNT || ' Current amout: ' ||
                             (t_original_amount_meas.COUNT + (p_row_amount * t_report.COUNT)) || '.');
    END add_multiple_measurements;


    PROCEDURE
        bewijs_milestone_M5_S2(p_aantal_w_laboraties IN NUMERIC, p_aantal_x_measurements IN NUMERIC,
                               p_aantal_y_reports_x IN NUMERIC, p_aantal_z_campaigns_y IN NUMERIC)
    AS
        ts1
            timestamp;
        ts2 timestamp;
    BEGIN
        ts1 := SYSTIMESTAMP;

        add_multiple_laboratories(p_aantal_w_laboraties);
        add_multiple_campaigns(p_aantal_x_measurements);
        add_multiple_reports(p_aantal_y_reports_x);
        add_multiple_measurements(p_aantal_z_campaigns_y);


        ts2 := SYSTIMESTAMP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                             'The duration of the total line generation was: ' || timestamp_diff(ts2, ts1) ||
                             ' seconds');

    END bewijs_milestone_M5_S2;

END PKG_SAMENS2_M5_LABORATORIES;
/

