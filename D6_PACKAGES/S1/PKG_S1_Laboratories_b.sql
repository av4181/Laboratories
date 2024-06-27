CREATE PACKAGE BODY PKG_S1_LABORATORIES
AS
    -- Table types voor ID's
    TYPE t_tab_meas IS TABLE OF MEASUREMENTS.MEASUREMENT_ID%TYPE INDEX BY PLS_INTEGER;
    TYPE t_tab_labs IS TABLE OF LABORATORIES.LABORATORY_ID%TYPE INDEX BY PLS_INTEGER;
    TYPE t_tab_lab_technicians IS TABLE OF LAB_TECHNICIANS.TECHNICIAN_ID%TYPE INDEX BY PLS_INTEGER;
    TYPE t_tab_instruments IS TABLE OF INSTRUMENTS.INSTRUMENT_ID%TYPE INDEX BY PLS_INTEGER;
    TYPE t_tab_samples IS TABLE OF SAMPLES.SAMPLE_ID%TYPE INDEX BY PLS_INTEGER;

    -- Table types voor ROWTYPES

    TYPE t_tab_meas_new IS TABLE OF MEASUREMENTS%ROWTYPE;
    TYPE t_tab_labs_new IS TABLE OF LABORATORIES%ROWTYPE;
    TYPE t_tab_lab_technicians_new IS TABLE OF LAB_TECHNICIANS%ROWTYPE;
    TYPE t_tab_instruments_new IS TABLE OF INSTRUMENTS%ROWTYPE;
    TYPE t_tab_samples_new IS TABLE OF SAMPLES%ROWTYPE;

    -- Table types random functies
    TYPE t_tab_instruments_desc IS TABLE OF INSTRUMENTS.INSTRUMENT_DESCRIPTION%TYPE;
    TYPE t_tab_instrument_name IS TABLE OF INSTRUMENTS.INSTRUMENT_NAME%TYPE;
    TYPE t_tab_names IS TABLE OF LABORATORIES.LABORATORY_NAME%TYPE;
    TYPE type_tab_streetNames IS TABLE OF LABORATORIES.LABORATORY_STREET%TYPE;
    TYPE t_tab_Locations IS TABLE OF LABORATORIES.LABORATORY_LOCATION%TYPE;
    TYPE t_tab_companies IS TABLE OF LABORATORIES.COMPANY%TYPE;
    TYPE t_tab_unit IS TABLE OF MEASUREMENTS.UNIT%TYPE;
    TYPE t_tab_sample_description IS TABLE OF SAMPLES.SAMPLE_DESCRIPTION%TYPE;

    -- EMPTY TABLES --
    -- Publiek --
    PROCEDURE empty_tables_S1
    AS
    BEGIN
        BEGIN
            EXECUTE IMMEDIATE 'TRUNCATE TABLE MEASUREMENTS';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE LAB_TECHNICIANS';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE SAMPLES';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE INSTRUMENTS';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE LABORATORIES';

--             EXECUTE IMMEDIATE 'SET CONSTRAINT LABORATORY_LAB_TECHNICIANS_FK DEFERRED';
--             EXECUTE IMMEDIATE  'PURGE dba_recyclebin';
            EXECUTE IMMEDIATE 'ALTER TABLE MEASUREMENTS MODIFY MEASUREMENT_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
            EXECUTE IMMEDIATE 'ALTER TABLE LAB_TECHNICIANS MODIFY TECHNICIAN_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
            EXECUTE IMMEDIATE 'ALTER TABLE SAMPLES MODIFY SAMPLE_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
            EXECUTE IMMEDIATE 'ALTER TABLE INSTRUMENTS MODIFY INSTRUMENT_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
            EXECUTE IMMEDIATE 'ALTER TABLE Laboratories MODIFY LABORATORY_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error truncating tables: ' || SQLERRM);
        END;
    END empty_tables_S1;

    -- Zoek functies M4 --
    FUNCTION lookup_lab_technician(p_lab_technician_first_name IN Lab_Technicians.First_Name%TYPE,
                                   p_lab_technician_last_name IN Lab_Technicians.Last_Name%TYPE)
        RETURN Lab_Technicians.Technician_ID%TYPE
    AS
        v_technician_id Lab_Technicians.Technician_ID%TYPE;
    BEGIN
        SELECT Technician_ID
        INTO v_technician_id
        FROM Lab_Technicians
        WHERE UPPER(First_Name) = UPPER(p_lab_technician_first_name)
          AND UPPER(Last_Name) = UPPER(p_lab_technician_last_name);
        RETURN v_technician_id;
    EXCEPTION
        WHEN NO_DATA_FOUND then
            return null;
    END lookup_lab_technician;

    FUNCTION lookup_laboratory(p_laboratory_name IN Laboratories.Laboratory_Name%TYPE)
        RETURN Laboratories.Laboratory_ID%TYPE
    AS
        v_laboratory_id Laboratories.Laboratory_ID%TYPE;
    BEGIN
        SELECT Laboratory_ID
        INTO v_laboratory_id
        FROM Laboratories
        WHERE UPPER(Laboratory_Name) = UPPER(p_laboratory_name);

        RETURN v_laboratory_id;
    EXCEPTION
        WHEN NO_DATA_FOUND then
            return null;
    END lookup_laboratory;

    FUNCTION lookup_instrument(p_instrument_description IN Instruments.Instrument_DESCRIPTION%TYPE)
        RETURN Instruments.Instrument_ID%TYPE
    AS
        v_instrument_id Instruments.Instrument_ID%TYPE;
    BEGIN
        SELECT Instrument_ID
        INTO v_instrument_id
        FROM Instruments
        WHERE UPPER(INSTRUMENT_DESCRIPTION) = UPPER(p_instrument_description);

        RETURN v_instrument_id;
    EXCEPTION
        WHEN NO_DATA_FOUND then
            return null;
    END lookup_instrument;

    FUNCTION lookup_sample(p_sample_description IN Samples.Sample_Description%TYPE)
        RETURN Samples.Sample_ID%TYPE
    AS
        v_sample_id Samples.Sample_ID%TYPE;
    BEGIN
        SELECT Sample_ID
        INTO v_sample_id
        FROM Samples
        WHERE UPPER(Sample_Description) = UPPER(p_sample_description);

        RETURN v_sample_id;
    EXCEPTION
        WHEN NO_DATA_FOUND then
            return null;
    END lookup_sample;

    FUNCTION lookup_measurement(p_start_date IN Measurements.Measurement_Start_Date%TYPE)
        RETURN Measurements.Measurement_ID%TYPE
    AS
        v_measurement_id Measurements.Measurement_ID%TYPE;
    BEGIN
        SELECT Measurement_ID
        INTO v_measurement_id
        FROM Measurements
        WHERE Measurement_Start_Date = p_start_date;

        RETURN v_measurement_id;
    EXCEPTION
        WHEN NO_DATA_FOUND then
            return null;
    END lookup_measurement;

    -- ADD PROCEDURES M4 --
    -- Private --
    PROCEDURE add_lab_technician (
        p_first_name IN Lab_Technicians.First_Name%TYPE,
        p_last_name IN Lab_Technicians.Last_Name%TYPE,
        p_gender IN Lab_Technicians.Gender%TYPE,
        p_function IN Lab_Technicians.Function%TYPE,
        p_start_date IN Lab_Technicians.Function_Start_Date%TYPE,
        p_end_date IN Lab_Technicians.Function_End_Date%TYPE,
        p_laboratory_name IN Laboratories.Laboratory_Name%TYPE)
    AS
        v_laboratory Laboratories.LABORATORY_ID%TYPE:= lookup_laboratory(p_laboratory_name);
    BEGIN
        INSERT INTO Lab_Technicians (Laboratory_ID,
                                     First_Name,
                                     Last_Name,
                                     Gender,
                                     "FUNCTION",
                                     Function_Start_Date,
                                     Function_End_Date)
        VALUES (
                                    v_laboratory,
                                    p_first_name,
                                    p_last_name,
                                    p_gender,
                                    p_function,
                                    p_start_date,
                                    p_end_date
                 );
    END add_lab_technician;

    PROCEDURE add_laboratory (
            p_laboratory_name IN Laboratories.Laboratory_Name%TYPE,
            p_company IN Laboratories.Company%TYPE,
            p_street IN Laboratories.Laboratory_Street%TYPE,
            p_house_number IN Laboratories.LABORATORY_STREET_NUMBER%TYPE,
            p_description IN Laboratories.Laboratory_Description%TYPE,
            p_location IN Laboratories.Laboratory_Location%TYPE)
    AS
    BEGIN
        INSERT INTO Laboratories (
                            Laboratory_Name,
                            Company,
                            Laboratory_Street,
                            LABORATORY_STREET_NUMBER,
                            Laboratory_Description,
                            Laboratory_Location
                            )
        VALUES (
                 p_laboratory_name,
                 p_company,
                 p_street,
                 p_house_number,
                 p_description,
                 p_location
             );
    END add_laboratory;

    PROCEDURE add_instrument (
        p_instrument_description IN Instruments.Instrument_Description%TYPE,
        p_instrument_name IN Instruments.Instrument_Name%TYPE,
        p_cost IN Instruments.Instrument_Cost%TYPE)
    AS
    BEGIN
        INSERT INTO Instruments (
            Instrument_Description,
            Instrument_Name,
            Instrument_Cost)
        VALUES (
                     p_instrument_description,
                     p_instrument_name,
                     p_cost
                 );
    END add_instrument;

    PROCEDURE add_sample (
        p_sample_description IN Samples.Sample_Description%TYPE,
        p_sample_status IN Samples.Sample_Status%TYPE,
        p_sampling_date IN Samples.Sampling_Date%TYPE,
        p_sample_point IN Samples.Samplepoint%TYPE,
        p_sample_type IN Samples.Sample_Type%TYPE,
        p_product IN Samples.Product%TYPE)
    AS
    BEGIN
        INSERT INTO Samples (
            Sample_Description,
            Sample_Status,
            Sampling_Date,
            Samplepoint,
            Sample_Type,
            Product)
        VALUES (
                     p_sample_description,
                     p_sample_status,
                     p_sampling_date,
                     p_sample_point,
                     p_sample_type,
                     p_product);
    END add_sample;

    PROCEDURE add_measurement (
        p_start_date IN Measurements.Measurement_Start_Date%TYPE,
        p_end_date IN Measurements.Measurement_End_Date%TYPE,
        p_result IN Measurements.Result%TYPE,
        p_unit IN Measurements.Unit%TYPE,
        p_cost IN Measurements.Measurement_Cost%TYPE,
        p_sample_description IN Samples.Sample_Description%TYPE,
        p_instrument_description IN Instruments.INSTRUMENT_DESCRIPTION%TYPE,
        p_technician_first_name IN Lab_technicians.First_Name%TYPE,
        p_technician_last_name IN Lab_technicians.Last_Name%TYPE)
    AS
        v_sample SAMPLES.SAMPLE_ID%TYPE:= lookup_sample(p_sample_description);
        v_instrument INSTRUMENTS.INSTRUMENT_ID%TYPE:= lookup_instrument(p_instrument_description);
        v_technician LAB_TECHNICIANS.TECHNICIAN_ID%TYPE:= lookup_lab_technician(p_technician_first_name,
            p_technician_last_name);
    BEGIN
        INSERT INTO Measurements (
            Sample_ID,
            Instrument_ID,
            Technician_ID,
            Measurement_Start_Date,
            Measurement_End_Date,
            Result,
            Unit,
            Measurement_Cost)
        VALUES (

                     v_sample,
                     v_instrument,
                     v_technician,
                     p_start_date,
                     p_end_date,
                     p_result,
                     p_unit,
                     p_cost);
    END add_measurement;

    PROCEDURE add_lab_technicians_samen
    AS
    BEGIN
        add_lab_technician('Bruno', 'Willems', 'M', 'Manager', TO_DATE('29/09/05', 'DD/MM/YYYY'), NULL, 'VITO');
        add_lab_technician('An', 'Jacobs', 'V', 'Technician', TO_DATE('15/01/2010', 'DD/MM/YYYY'), NULL, 'UZA');
        add_lab_technician('Katrien', 'Wauters', 'V', 'Technician', TO_DATE('10/07/1978', 'DD/MM/YYYY'), NULL,
                           'UZA');
        add_lab_technician('Tom', 'Peeters', 'M', 'Shiftleader', TO_DATE('01/11/1982', 'DD/MM/YYYY'), NULL,
                           'Klinisch labo AZM');
        add_lab_technician('Inge', 'De Smet', 'V', 'Technician', TO_DATE('01/02/1999', 'DD/MM/YYYY'), NULL, 'UZA');

        DBMS_OUTPUT.PUT_LINE('Restored Lab Technicians');
    END add_lab_technicians_samen;

    PROCEDURE bewijs_Milestone_M4_S1
    AS
    BEGIN
        add_laboratory('VITO', 'Overheid', 'BOERETANG', 200 , 'Labo voor grondstalen', 'Mol');
        add_laboratory('UZA', 'Overheid', 'DRIE EIKENSTRAAT', 655 , 'Chemie', 'Edegem');
        add_laboratory('AZ Voorkempen', 'Overheid', 'OUDE LIERSEBAAN', 4 , 'Microbiologie', 'Malle');
        add_laboratory('Klinisch labo AZM', 'Overheid', 'FLORENT PAUWELSLEI', 1 , 'Toxicologie', 'Deurne');
        add_laboratory('Insituut voor tropische geneeskunde', 'Overheid', 'KRONENBURGSTRAAT', 433, 'Toxicologie', 'Deurne');

        add_instrument('Chromotography', 'GE Multiskan', '€500');
        add_instrument('Spectroscopy', 'Siemens Spectro', '€1100');
        add_instrument('Calory', 'ABB XL', '€105');
        add_instrument('Luminometer', 'Lumac', '€805');
        add_instrument('pH Measurement', 'Hach Lange', '€125');

        add_sample('Tank B600','SHIPPED', '20/10/22 10:35:00', 'QT501010', 'inline', 'benzene');
        add_sample('Water Treatment','CANCELLED', '03/01/23 10:35:00', 'QI10005', 'probe', 'water');
        add_sample('Extruder','FINAL', '08/01/20 08:15:11', 'Q123456', 'QA', 'polymer');
        add_sample('Flare','FINAL', '30/03/24 09:54:00', 'QIC65124', 'Emissions', 'VOC');
        add_sample('Ship Unloading','SHIPPED', '01/12/22 15:26:01', 'Q789456', 'Imports', 'nafta');

        add_lab_technician('Bruno','Willems','M','Manager',TO_DATE('29/09/05','DD/MM/YYYY'),NULL,'VITO');
        add_lab_technician('An','Jacobs','V','Technician',TO_DATE('15/01/2010','DD/MM/YYYY'),NULL,'UZA');
        add_lab_technician('Katrien','Wauters','V','Technician',TO_DATE('10/07/1978','DD/MM/YYYY'),NULL,'UZA');
        add_lab_technician('Tom','Peeters','M','Shiftleader',TO_DATE('01/11/1982','DD/MM/YYYY'),NULL,'Klinisch labo AZM');
        add_lab_technician('Inge','De Smet','V','Technician',TO_DATE('01/02/1999','DD/MM/YYYY'),NULL,'UZA');

        add_measurement('01/02/22 10:00:00',
                        '01/02/22 12:00:00',
                        500,
                        'ppm',
                        95,
                        'Water Treatment',
                        'pH Measurement',
                        'An',
                        'Jacobs');
        add_measurement('05/03/23 16:00:00',
                        '06/03/23 09:00:00',
                        7.1,
                        'pH',
                        70,
                        'Water Treatment',
                        'pH Measurement',
                        'Tom',
                        'Peeters');
        add_measurement('01/10/19 15:00:00',
                        '02/10/19 16:00:00',
                        20,
                        'wt-%',
                        205,
                        'Water Treatment',
                        'Spectroscopy',
                        'An',
                        'Jacobs');
        add_measurement('11/11/15 10:00:00',
                        '11/11/15 13:00:00',
                        40000,
                        'kJ/kg',
                        95,
                        'Flare',
                        'Calory',
                        'Katrien',
                        'Wauters');
        add_measurement('30/08/21 11:00:00',
                        '01/09/21 13:00:00',
                        10,
                        'wt-%',
                        205,
                        'Extruder',
                        'Spectroscopy',
                        'Katrien',
                        'Wauters');
    END bewijs_Milestone_M4_S1;

    -- M5 --
    --Private random functies--
    --general--
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

    -- Instrument --

    FUNCTION random_instrument_description
        return INSTRUMENTS.INSTRUMENT_DESCRIPTION%TYPE
    AS
        t_description        t_tab_instruments_desc := t_tab_instruments_desc('Chromotography',
                                                                    'Spectroscopy',
                                                                    'Calory',
                                                                    'Luminometer',
                                                                    'pH Measurement');
        v_description_picker NUMERIC       := random_number(1, t_description.COUNT);
    BEGIN
        return t_description(v_description_picker);
    END random_instrument_description;

    FUNCTION random_instrument_name
        RETURN INSTRUMENTS.INSTRUMENT_NAME%TYPE
    AS
        t_instrument_name        t_tab_instrument_name := t_tab_instrument_name('GE',
                                                                                'Siemens',
                                                                                'ABB',
                                                                                'Lumac',
                                                                                'Hach Lange');

        v_instrument_name_picker NUMERIC       := random_number(1, t_instrument_name.COUNT);
        v_random_number          NUMERIC(6)     := FLOOR(random_number(100000,999999));
    BEGIN
        RETURN t_instrument_name(v_instrument_name_picker) || '_' || TO_CHAR(v_random_number);
    END random_instrument_name;

    -- Lab_technicians --
    FUNCTION random_function
        RETURN LAB_TECHNICIANS.FUNCTION%TYPE
        IS
        TYPE type_varray_type IS VARRAY (3) OF VARCHAR2(50);
        t_type type_varray_type := type_varray_type('Technician', 'Shiftleader', 'Manager');
    BEGIN
        RETURN t_type(random_number(1, t_type.COUNT));
    END random_function;

    FUNCTION random_firstname
        RETURN LAB_TECHNICIANS.FIRST_NAME%TYPE
        IS
        TYPE type_tab_first_name IS TABLE of LAB_TECHNICIANS.FIRST_NAME%TYPE;
        t_firstname type_tab_first_name := type_tab_first_name('Stef', 'Andreas', 'Bart', 'Jos', 'Ann', 'Abby',
                                                              'Bianca', 'Lorenz', 'Paul', 'Laura', 'Anouk', 'Zoë',
                                                              'Davy', 'Maarten', 'Jiri', 'Mike', 'Nils', 'Geert',
                                                              'Leen', 'Regina', 'Jan-Willem','Jef','Nik','Dominique',
                                                                'Tim','Tinne','Cloe','Katrien','Els','Constant','Jacques',
                                                                'Dirk','Thierry','Wendy','Sarah','Annie','Jean','Jack',
                                                                'Jonas','Eline','Nils','Robin','Theo','Sabine');

    BEGIN
        RETURN t_firstname(random_number(1, t_firstname.COUNT));
    END random_firstname;

    FUNCTION random_lastname
        RETURN LAB_TECHNICIANS.LAST_NAME%TYPE
        IS
        TYPE type_tab_last_name IS TABLE of LAB_TECHNICIANS.LAST_NAME%TYPE;
        t_lastname type_tab_last_name := type_tab_last_name('De Smet', 'Jacobs', 'Peeters', 'Janssens', 'Maes',
                                                            'Willems', 'Claes', 'Goossens', 'Wouters', 'De Clercq',
                                                            'Lucas', 'Martin', 'Dupont', 'Dubois', 'Lambert',
                                                            'Lefebvre', 'Desmet', 'Dubois', 'Vermeulen', 'Van Damme',
                                                            'Verhoeven', 'De Jong', 'Van den Berg', 'De Vries',
                                                            'Jansen', 'Van Dijk', 'Bakker', 'Janssen', 'Smit',
                                                            'Meijer', 'De Groot', 'Visser', 'Bos', 'Mulder','De Wit',
                                                            'Peters', 'Hendriks', 'Van Leeuwen', 'Dekker', 'Brouwer',
                                                            'De Haan', 'Van den Bosch', 'Sanders', 'De Vos', 'Van der Linden',
                                                            'De Bruijn', 'Van den Broek','Van de Ven', 'Groen',
                                                            'Van der Heijden', 'De Bruin', 'Bakker', 'Verbeek', 'Van Loon',
                                                            'Willemsen', 'Timmermans', 'Van de Velde', 'Van den Heuvel',
                                                            'De Graaf', 'Blom', 'Kramer', 'De Leeuw', 'Kuipers', 'Van der Molen',
                                                            'Van der Velden', 'Hermans', 'Martens');

    BEGIN
        RETURN t_lastname(random_number(1, t_lastname.COUNT));
    END random_lastname;

    FUNCTION random_gender
        RETURN LAB_TECHNICIANS.GENDER%TYPE
        IS
        TYPE type_varray_type IS VARRAY (5) OF VARCHAR2(50);
        t_type type_varray_type := type_varray_type('M', 'V', 'X');
    BEGIN
        RETURN t_type(random_number(1, t_type.COUNT));
    END random_gender;

    -- Laboratory --
    FUNCTION random_lab_name
        RETURN LABORATORIES.LABORATORY_NAME%TYPE
    AS
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
        t_companies      t_tab_companies := t_tab_companies('LAMBO Laboratories', 'Saybolt Belgium',
                                                            'Alcon Laboratories Belgium', 'AgomAb Therapeutics',
                                                            'atbtherapeutics', 'Biocartis', 'Innovad Laboratories',
                                                            'Ablynx',
                                                            'TiGenix', 'MaSTherCell', 'Bone Therapeutics',
                                                            'Delphi Genetics',
                                                            'Catalent Pharma', 'Sanofi', 'Takeda', 'ArgenX',
                                                            'V-Bio Ventures',
                                                            'Advent France Biotechnology', 'AstraZeneca',
                                                            'Financière Spin Off Luxembourgeoise', 'BASF', 'VITO',
                                                            'UZA');
        v_company_picker NUMERIC         := random_number(1, t_companies.COUNT);
    BEGIN
        return t_companies(v_company_picker);
    END;

    -- Measurement--
    FUNCTION random_unit
        return MEASUREMENTS.UNIT%TYPE
    AS
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

    -- Sample--
    FUNCTION random_sample_description
        RETURN SAMPLES.SAMPLE_DESCRIPTION%TYPE
    AS
        t_sample_description        t_tab_sample_description := t_tab_sample_description('Tank B',
                                                                                'Column C',
                                                                                'Vessel V',
                                                                                'Flare F',
                                                                                'Extruder E');

        v_sample_description_picker NUMERIC       := random_number(1, t_sample_description.COUNT);
        v_random_number          NUMERIC(6)     := FLOOR(random_number(1000,9999));
    BEGIN
        RETURN t_sample_description(v_sample_description_picker) || '' || TO_CHAR(v_random_number);
    END random_sample_description;


    FUNCTION random_sample_status
        RETURN SAMPLES.SAMPLE_STATUS%TYPE
        IS
        TYPE type_varray_type IS VARRAY (5) OF VARCHAR2(50);
        t_type type_varray_type := type_varray_type('SHIPPED', 'CANCELLED', 'FINAL');
    BEGIN
        RETURN t_type(random_number(1, t_type.COUNT));
    END random_sample_status;

    -- Time functions
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


    -- Generate procedures M5 --
    --  VEEL OP VEEL
    PROCEDURE add_random_laboratory(
        p_count IN NUMBER DEFAULT 1
    )
    AS
        v_laboratory_name        LABORATORIES.LABORATORY_NAME%TYPE;
        v_laboratory_description LABORATORIES.LABORATORY_DESCRIPTION%TYPE;
        v_laboratory_street      LABORATORIES.LABORATORY_STREET%TYPE;
        v_laboratory_street_nr   LABORATORIES.LABORATORY_STREET_NUMBER%TYPE;
        v_laboratory_location    LABORATORIES.LABORATORY_LOCATION%TYPE;
        v_laboratory_company     LABORATORIES.COMPANY%TYPE;
        t_original_amount_labs   t_tab_labs;
        v_starttimestamp       TIMESTAMP;
    BEGIN
        v_starttimestamp := SYSTIMESTAMP;

        SELECT LABORATORY_ID BULK COLLECT
        INTO t_original_amount_labs
        from LABORATORIES;

        FOR i in 1 ..p_count
            LOOP
                v_laboratory_name := random_lab_name();
                v_laboratory_description := NULL;
                v_laboratory_street := random_street();
                v_laboratory_street_nr := random_number(0, 300);
                v_laboratory_location := random_location();
                v_laboratory_company := random_company();

                add_laboratory(v_laboratory_name,
                               v_laboratory_company,
                               v_laboratory_street,
                               v_laboratory_street_nr,
                               v_laboratory_description,
                               v_laboratory_location);
            END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                             'add_multiple_laboratories with parameter input: ' || p_count || ' generated ' ||
                             (p_count) || ' lines. The generation time for this procedure was ' ||
                             timestamp_diff(SYSTIMESTAMP, v_starttimestamp) || ' seconds.' || u'\000D\000A' ||
                             'original amount: ' || t_original_amount_labs.COUNT || ' Current amount: ' ||
                             (t_original_amount_labs.COUNT + (p_count)) || '.');
    END add_random_laboratory;

    PROCEDURE add_random_technician(
        p_count IN NUMBER DEFAULT 1
    )
    AS
        v_technician_first_name LAB_TECHNICIANS.FIRST_NAME%TYPE;
        v_technician_last_name  LAB_TECHNICIANS.LAST_NAME%TYPE;
        v_technician_gender     LAB_TECHNICIANS.GENDER%TYPE;
        v_technician_function   LAB_TECHNICIANS.FUNCTION%TYPE;
        v_technician_start_date LAB_TECHNICIANS.FUNCTION_START_DATE%TYPE;
        v_technician_end_date   LAB_TECHNICIANS.FUNCTION_END_DATE%TYPE;
        v_laboratory_name       LABORATORIES.LABORATORY_NAME%TYPE;
        v_laboratory_ID         LABORATORIES.LABORATORY_ID%TYPE;
        v_max_labID             LABORATORIES.LABORATORY_ID%TYPE;
        t_original_amount_technicians t_tab_lab_technicians;
        v_starttimestamp       TIMESTAMP;
    BEGIN
        v_starttimestamp := SYSTIMESTAMP;

        SELECT MAX(LABORATORY_ID)
        INTO v_max_labID
        from LABORATORIES;

        SELECT TECHNICIAN_ID BULK COLLECT
        INTO t_original_amount_technicians
        from LAB_TECHNICIANS;

        FOR i in 1 ..p_count
            LOOP
                v_laboratory_ID := random_number(1, v_max_labID);
                v_technician_first_name := random_firstname();
                v_technician_last_name := random_lastname();
                v_technician_gender := random_gender();
                v_technician_function := random_function();
                v_technician_start_date := random_date(SYSDATE - 365, SYSDATE);
                v_technician_end_date := random_date(v_technician_start_date, SYSDATE);
                v_laboratory_name := random_lab_name();

                insert into LAB_TECHNICIANS(laboratory_id, supervisor_id, first_name, last_name, gender, function,
                                            function_start_date, function_end_date)
                values (v_laboratory_ID, null, v_technician_first_name, v_technician_last_name, v_technician_gender,
                        v_technician_function,
                        v_technician_start_date, v_technician_end_date);

            END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                             'add_multiple_technicians with parameter input: ' || p_count || ' generated ' ||
                             (p_count) || ' lines. The generation time for this procedure was ' ||
                             timestamp_diff(SYSTIMESTAMP, v_starttimestamp) || ' seconds.' || u'\000D\000A' ||
                             'original amount: ' || t_original_amount_technicians.COUNT || ' Current amount: ' ||
                             (t_original_amount_technicians.COUNT + (p_count)) || '.');
    END add_random_technician;

    PROCEDURE
        add_random_instrument(
        p_count IN NUMBER DEFAULT 1
    ) AS
        v_instrument_description INSTRUMENTS.INSTRUMENT_DESCRIPTION%TYPE;
        v_instrument_name        INSTRUMENTS.INSTRUMENT_NAME%TYPE;
        v_instrument_cost        INSTRUMENTS.INSTRUMENT_COST%TYPE;
        t_original_amount_instruments t_tab_instruments;
        v_starttimestamp       TIMESTAMP;
    BEGIN
        v_starttimestamp := SYSTIMESTAMP;

        SELECT INSTRUMENT_ID BULK COLLECT
        INTO t_original_amount_instruments
        from INSTRUMENTS;

        FOR i in 1 ..p_count
            LOOP
                v_instrument_description := random_instrument_description();
                v_instrument_name := random_instrument_name();
                v_instrument_cost := '€' || random_number(0, 10000);

                insert into INSTRUMENTS(instrument_description, instrument_name, instrument_cost)
                VALUES (v_instrument_description,
                        v_instrument_name,
                        v_instrument_cost);

            END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                            'add_multiple_instruments with parameter input: ' || p_count || ' generated ' ||
                            (p_count) || ' lines. The generation time for this procedure was ' ||
                            timestamp_diff(SYSTIMESTAMP, v_starttimestamp) || ' seconds.' || u'\000D\000A' ||
                            'original amount: ' || t_original_amount_instruments.COUNT || ' Current amount: ' ||
                            (t_original_amount_instruments.COUNT + (p_count)) || '.');
    END add_random_instrument;

    PROCEDURE
        add_random_sample(
        p_count IN NUMBER DEFAULT 1
    ) AS
        v_sample_description SAMPLES.SAMPLE_DESCRIPTION%TYPE;
        v_sample_status      SAMPLES.SAMPLE_STATUS%TYPE;
        v_sample_date        SAMPLES.SAMPLING_DATE%TYPE;
        v_sample_samplepoint SAMPLES.SAMPLEPOINT%TYPE;
        v_sample_type        SAMPLES.SAMPLE_TYPE%TYPE;
        v_sample_product     SAMPLES.PRODUCT%TYPE;
        t_original_amount_samples t_tab_samples;
        v_starttimestamp       TIMESTAMP;
    BEGIN
        v_starttimestamp := SYSTIMESTAMP;

        SELECT SAMPLE_ID BULK COLLECT
        INTO t_original_amount_samples
        from SAMPLES;

        FOR i in 1 ..p_count
            LOOP
                v_sample_description := random_sample_description();
                v_sample_status := random_sample_status();
                v_sample_date := random_date(SYSDATE - 365, SYSDATE);
                v_sample_samplepoint := 'Q' || random_number(0, 999999);
                v_sample_type := 'Sample type_' || i;
                v_sample_product := 'Sample product_' || i;

                add_sample(v_sample_description,
                           v_sample_status,
                           v_sample_date,
                           v_sample_samplepoint,
                           v_sample_type,
                           v_sample_product);
            END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                             'add_multiple_samples with parameter input: ' || p_count || ' generated ' ||
                             (p_count) || ' lines. The generation time for this procedure was ' ||
                             timestamp_diff(SYSTIMESTAMP, v_starttimestamp) || ' seconds.' || u'\000D\000A' ||
                             'original amount: ' || t_original_amount_samples.COUNT || ' Current amount: ' ||
                             (t_original_amount_samples.COUNT + (p_count)) || '.');
    END add_random_sample;


    PROCEDURE
        add_random_measurement(
        p_count IN NUMBER DEFAULT 1
    ) AS

        v_start_date      MEASUREMENTS.MEASUREMENT_START_DATE%TYPE;
        v_end_date        MEASUREMENTS.MEASUREMENT_END_DATE%TYPE;
        v_result          MEASUREMENTS.RESULT%TYPE;
        v_unit            MEASUREMENTS.UNIT%TYPE;
        v_cost            MEASUREMENTS.MEASUREMENT_COST%TYPE;
        v_sample_id       SAMPLES.SAMPLE_ID%TYPE;
        v_instrument_id   INSTRUMENTS.INSTRUMENT_ID%TYPE;
        v_technician_id   LAB_TECHNICIANS.TECHNICIAN_ID%TYPE;
        v_max_samples     SAMPLES.SAMPLE_ID%TYPE;
        v_max_instruments INSTRUMENTS.INSTRUMENT_ID%TYPE;
        v_max_technicians LAB_TECHNICIANS.TECHNICIAN_ID%TYPE;
        t_original_amount_measurements t_tab_meas;
        v_starttimestamp       TIMESTAMP;
    BEGIN
        v_starttimestamp := SYSTIMESTAMP;
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
        INTO t_original_amount_measurements
        from MEASUREMENTS;

        FOR i IN 1 .. p_count
            LOOP
                v_start_date := random_timestamp(SYSDATE - 30, SYSDATE);
                v_end_date := random_timestamp(v_start_date + NUMTODSINTERVAL(1, 'SECOND'),
                                               v_start_date + NUMTODSINTERVAL(12, 'HOUR'));
                v_result := random_decimal_number(1, 1000, 2);
                v_unit := random_unit();
                v_cost := random_decimal_number(50, 500, 2);
                v_sample_id := random_number(1, v_max_samples);
                v_instrument_id := random_number(1, v_max_instruments);
                v_technician_id := random_number(1, v_max_technicians);

                insert into MEASUREMENTS(MEASUREMENT_START_DATE, MEASUREMENT_END_DATE, RESULT, UNIT,
                                         MEASUREMENT_COST, SAMPLE_ID, INSTRUMENT_ID, TECHNICIAN_ID)
                values (v_start_date,
                        v_end_date,
                        v_result,
                        v_unit,
                        v_cost,
                        v_sample_id,
                        v_instrument_id,
                        v_technician_id);

            END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                             'add_multiple_measurements with parameter input: ' || p_count || ' generated ' ||
                             (p_count) || ' lines. The generation time for this procedure was ' ||
                             timestamp_diff(SYSTIMESTAMP, v_starttimestamp) || ' seconds.' || u'\000D\000A' ||
                             'original amount: ' || t_original_amount_measurements.COUNT || ' Current amount: ' ||
                             (t_original_amount_measurements.COUNT + (p_count)) || '.');
    END add_random_measurement;

    -- Algemene generatie van deel veel_op_veel
    PROCEDURE
        bewijs_milestone_M5_S1(
        p_amount_lab_technicians IN NUMBER DEFAULT 1,
        p_amount_samples IN NUMBER DEFAULT 1,
        p_amount_instruments IN NUMBER DEFAULT 1,
        p_amount_measurements IN NUMBER DEFAULT 1
    ) AS
        ts1
            timestamp;
        ts2 timestamp;
    BEGIN
        ts1 := SYSTIMESTAMP;
        --EXECUTE IMMEDIATE 'SET CONSTRAINT LABORATORY_LAB_TECHNICIANS_FK DEFERRED';
        add_random_laboratory(3000);
        --EXECUTE IMMEDIATE 'COMMIT';
        add_random_technician(p_amount_lab_technicians);
        --EXECUTE IMMEDIATE 'COMMIT';
        add_random_sample(p_amount_samples);
        --EXECUTE IMMEDIATE 'COMMIT';
        add_random_instrument(p_amount_instruments);
        --EXECUTE IMMEDIATE 'COMMIT';
        add_random_measurement(p_amount_measurements);
        --EXECUTE IMMEDIATE 'COMMIT';
        ts2 := SYSTIMESTAMP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                             'The duration of the total line generation was: ' || timestamp_diff(ts2, ts1) ||
                             ' seconds');

    END bewijs_milestone_M5_S1;

 --   Bulk procedures M7
    PROCEDURE add_multiple_laboratories_M7(p_amount IN INTEGER)
    AS
        t_labs_new             t_tab_labs_new;
        v_original_amount_labs LABORATORIES.LABORATORY_ID%TYPE;
        v_amount_lines         NUMERIC;
        v_starttimestamp       TIMESTAMP;

    BEGIN
        v_starttimestamp := SYSTIMESTAMP;
        -- # bestaande records
        SELECT COUNT(*)
        INTO v_original_amount_labs
        FROM Laboratories;

        v_amount_lines := p_amount - v_original_amount_labs;
        --         t_labs_new := p_amount - t_original_amount_labs;

        -- INIT geneste tabel
        t_labs_new := t_tab_labs_new();

        -- Enkel benodigde aantal genereren
        IF v_amount_lines != 0 THEN

            FOR i IN 1..v_amount_lines
                LOOP
                    t_labs_new.EXTEND;
                    t_labs_new(i).Laboratory_Name := random_lab_name();
                    t_labs_new(i).Laboratory_Description := 'Lab Description ' || i;
                    t_labs_new(i).Laboratory_Street_Number := random_number(1, 999);
                    t_labs_new(i).Laboratory_Street := random_street();
                    t_labs_new(i).Laboratory_Location := random_location();
                    t_labs_new(i).Company := random_company();
                END LOOP;

            -- unieke namen
            FOR x IN 1..t_labs_new.COUNT
                LOOP
                    t_labs_new(x).Laboratory_Name := (t_labs_new(x).Laboratory_Name || '_' || x);
                END LOOP;

            -- Bulk Insert FORALL

            FORALL j IN INDICES OF t_labs_new
                INSERT INTO Laboratories (Laboratory_Name, Laboratory_Description, Laboratory_Street_Number,
                                          Laboratory_Street, Laboratory_Location, Company)
                VALUES (t_labs_new(j).Laboratory_Name, t_labs_new(j).Laboratory_Description,
                        t_labs_new(j).Laboratory_Street_Number, t_labs_new(j).Laboratory_Street,
                        t_labs_new(j).Laboratory_Location, t_labs_new(j).Company);

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                                 'add_multiple_laboratories with parameter input: ' || p_amount || ' generated ' ||
                                 t_labs_new.COUNT || ' lines. The generation time for this procedure was ' ||
                                 timestamp_diff(SYSTIMESTAMP, v_starttimestamp) || ' seconds.' || u'\000D\000A' ||
                                 'original amount: ' || v_original_amount_labs || ' Current amount: ' ||
                                 (v_original_amount_labs + t_labs_new.COUNT) || '.');

        ELSE
            DBMS_OUTPUT.PUT_LINE('Target number of laboratories already met.');
        END IF;
    END add_multiple_laboratories_M7;

    PROCEDURE add_multiple_technicians_M7(p_amount IN INTEGER)
    AS
        t_technicians_new                t_tab_lab_technicians_new;
        t_original_amount_technicians    t_tab_lab_technicians;
        v_starttimestamp                 TIMESTAMP;
        v_max_laboratory_id              LABORATORIES.LABORATORY_ID%TYPE;

    BEGIN
        v_starttimestamp := SYSTIMESTAMP;

        -- # bestaande records
        SELECT TECHNICIAN_ID BULK COLLECT
        INTO t_original_amount_technicians
        FROM LAB_TECHNICIANS;

        -- INIT geneste tabel
        t_technicians_new := t_tab_lab_technicians_new();

        -- Juiste LAB_ID referentie
        SELECT MAX(LABORATORY_ID)
        INTO v_max_laboratory_id
        FROM LABORATORIES;

        -- Enkel benodigde aantal genereren
        FOR i IN 1..p_amount
            LOOP
                t_technicians_new.EXTEND;
                -- random toewijzen LAB_ID
--                 SELECT Laboratory_ID
--                 INTO t_technicians_new(i).Laboratory_ID
--                 FROM LABORATORIES
--                 ORDER BY DBMS_RANDOM.VALUE()
--                 FETCH FIRST 1 ROW ONLY;

                t_technicians_new(i).Laboratory_ID := random_number(1, v_max_laboratory_id);
                t_technicians_new(i).First_Name := random_firstname();
                t_technicians_new(i).Last_Name  := random_lastname();
                t_technicians_new(i).Gender     := random_gender();
                t_technicians_new(i).Function   := random_function();
                t_technicians_new(i).Function_Start_Date := random_date(SYSDATE - 1825, SYSDATE);
                t_technicians_new(i).Function_End_Date   :=
                        CASE
                            WHEN random_number(1, 10) <= 8
                                THEN NULL
                            ELSE random_date(t_technicians_new(i).Function_Start_Date, SYSDATE)
                            END;
            END LOOP;

        FORALL j IN INDICES OF t_technicians_new
            INSERT INTO LAB_TECHNICIANS (Laboratory_ID, Supervisor_ID, First_Name, Last_Name, Gender, "FUNCTION",
                                         Function_Start_Date, Function_End_Date)
            VALUES (t_technicians_new(j).Laboratory_ID, t_technicians_new(j).Supervisor_ID, t_technicians_new(j).First_Name, t_technicians_new(j).Last_Name,
                    t_technicians_new(j).Gender, t_technicians_new(j).Function, t_technicians_new(j).Function_Start_Date, t_technicians_new(j).Function_End_Date);

        COMMIT;

        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                             'add_multiple_technicians_M7 with parameter input: ' || p_amount || ' generated ' ||
                             (p_amount) || ' lines. The generation time for this procedure was ' ||
                             timestamp_diff(SYSTIMESTAMP,v_starttimestamp) || ' seconds.' || u'\000D\000A' ||
                             'original amount: ' || t_original_amount_technicians.COUNT || ' Current amount: ' ||
                             (t_original_amount_technicians.COUNT + (p_amount)) || '.');

    END add_multiple_technicians_M7;

    PROCEDURE add_multiple_instruments_M7(p_amount IN INTEGER)
    AS
        t_instruments_new             t_tab_instruments_new;
        t_original_amount_instruments t_tab_instruments;
        v_starttimestamp               TIMESTAMP;
    BEGIN
        v_starttimestamp := SYSTIMESTAMP;

        -- # bestaande records
        SELECT Instrument_ID BULK COLLECT
        INTO t_original_amount_instruments
        FROM Instruments;

        -- INIT geneste tabel
        t_instruments_new := t_tab_instruments_new();

        -- Enkel benodigde aantal genereren
        FOR i IN 1..p_amount
            LOOP
                t_instruments_new.EXTEND;

                t_instruments_new(i).Instrument_Description := random_instrument_description();
                t_instruments_new(i).Instrument_Name        := random_instrument_name();
                t_instruments_new(i).Instrument_Cost        := '€' || TO_CHAR(random_number(100, 5000));
            END LOOP;



        FORALL j IN INDICES OF t_instruments_new
            INSERT INTO Instruments (Instrument_Description, Instrument_Name, Instrument_Cost)
            VALUES (t_instruments_new(j).Instrument_Description, t_instruments_new(j).Instrument_Name,
                    t_instruments_new(j).Instrument_Cost);

        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                             'add_multiple_instruments_M7 with parameter input: ' || p_amount || ' generated ' ||
                             (p_amount) || ' lines. The generation time for this procedure was ' ||
                             timestamp_diff(SYSTIMESTAMP, v_starttimestamp) || ' seconds.' || u'\000D\000A' ||
                             'original amount: ' || t_original_amount_instruments.COUNT || ' Current amount: ' ||
                             (t_original_amount_instruments.COUNT + (p_amount)) || '.');

    END add_multiple_instruments_M7;

    PROCEDURE add_multiple_samples_M7(
        p_count IN NUMBER DEFAULT 1
    )
    AS
        t_samples_new           t_tab_samples_new;
        t_original_amount_samples t_tab_samples;
        v_starttimestamp        TIMESTAMP;
    BEGIN
        v_starttimestamp := SYSTIMESTAMP;

        -- # bestaande records
        SELECT SAMPLE_ID BULK COLLECT INTO t_original_amount_samples FROM SAMPLES;

        -- INIT geneste tabel
        t_samples_new := t_tab_samples_new();

        -- Enkel benodigde aantal genereren
        FOR i IN 1..p_count
            LOOP
                t_samples_new.EXTEND;

                t_samples_new(i).Sample_Description := random_sample_description();
                t_samples_new(i).Sample_Status      := random_sample_status();
                t_samples_new(i).Sampling_Date      := random_timestamp(SYSTIMESTAMP - 365, SYSDATE);
                t_samples_new(i).Samplepoint        := 'Q' || TO_CHAR(random_number(0, 999999));
                t_samples_new(i).Sample_Type        := 'Sample type_' || i;
                t_samples_new(i).Product            := 'Product_' || i;
            END LOOP;

        FORALL j IN INDICES OF t_samples_new
            INSERT INTO Samples (
                Sample_Description,
                Sample_Status,
                Sampling_Date,
                Samplepoint,
                Sample_Type,
                Product
            ) VALUES (
                         t_samples_new(j).Sample_Description,
                         t_samples_new(j).Sample_Status,
                         t_samples_new(j).Sampling_Date,
                         t_samples_new(j).Samplepoint,
                         t_samples_new(j).Sample_Type,
                         t_samples_new(j).Product
                     );

        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                             'add_multiple_samples with parameter input: ' || p_count || ' generated ' ||
                             (p_count) || ' lines. The generation time for this procedure was ' ||
                             timestamp_diff(SYSTIMESTAMP, v_starttimestamp) || ' seconds.' || u'\000D\000A' ||
                             'original amount: ' || t_original_amount_samples.COUNT || ' Current amount: ' ||
                             (t_original_amount_samples.COUNT + (p_count)) || '.');

    END add_multiple_samples_M7;

    PROCEDURE add_multiple_measurements_M7(p_row_amount IN NUMERIC)
    AS
        t_original_amount_meas t_tab_meas;
        t_meas_new             t_tab_meas_new;
        v_counter              NUMERIC;
        v_starttimestamp       TIMESTAMP;
        v_max_samples          SAMPLES.SAMPLE_ID%TYPE;
        v_max_instruments      INSTRUMENTS.INSTRUMENT_ID%TYPE;
        v_max_technicians      LAB_TECHNICIANS.TECHNICIAN_ID%TYPE;
        v_first_timestamp      MEASUREMENTS.MEASUREMENT_START_DATE%TYPE;

    BEGIN
        v_starttimestamp := SYSTIMESTAMP;

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

        v_counter := p_row_amount;
        t_meas_new := t_tab_meas_new();

        for i in 1..v_counter
            LOOP
                t_meas_new.extend;

                v_first_timestamp :=
                        random_timestamp(SYSTIMESTAMP - NUMTODSINTERVAL(10, 'DAY'),
                                         SYSTIMESTAMP);
                t_meas_new(i).MEASUREMENT_START_DATE := v_first_timestamp;
                t_meas_new(i).MEASUREMENT_END_DATE :=
                        random_timestamp(v_first_timestamp + NUMTODSINTERVAL(1, 'SECOND'),
                                         SYSTIMESTAMP);
                t_meas_new(i).result := random_decimal_number(0.01, 1500, 2);
                t_meas_new(i).unit := random_unit();
                t_meas_new(i).MEASUREMENT_COST := random_decimal_number(1, 500, 2);
                t_meas_new(i).SAMPLE_ID := random_number(1, v_max_samples);
                t_meas_new(i).INSTRUMENT_ID := random_number(1, v_max_instruments);
                t_meas_new(i).TECHNICIAN_ID := random_number(1, v_max_technicians);
            END LOOP;

        FORALL x in indices of t_meas_new
            insert into MEASUREMENTS (SAMPLE_ID, INSTRUMENT_ID, TECHNICIAN_ID, measurement_start_date,
                                      measurement_end_date, result, unit, measurement_cost)
            values (t_meas_new(x).SAMPLE_ID, t_meas_new(x).INSTRUMENT_ID,
                    t_meas_new(x).TECHNICIAN_ID,
                    t_meas_new(x).MEASUREMENT_START_DATE,
                    t_meas_new(x).MEASUREMENT_END_DATE, t_meas_new(x).RESULT, t_meas_new(x).UNIT,
                    t_meas_new(x).MEASUREMENT_COST);

        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                             'add_multiple_measurement_bulk with parameter input: ' || p_row_amount || ' generated ' ||
                             (v_counter) || ' lines. The generation time for this procedure was ' ||
                             timestamp_diff(SYSTIMESTAMP,v_starttimestamp ) || ' seconds.');

    END add_multiple_measurements_M7;
--
--
--     PROCEDURE bewijs_milestone_M7_S1(p_aantal_a_samples  IN NUMERIC,p_aantal_b_technicians IN NUMERIC,
--                                      p_aantal_c_instruments IN NUMERIC, p_aantal_d_measurements IN NUMERIC,p_aantal_laboratories IN NUMERIC,
--                                      execute_M5 IN BOOLEAN)
--     AS
--         ts1 timestamp;
--         ts2 timestamp;
--     BEGIN
--         ts1 := SYSTIMESTAMP;
--         IF execute_M5 = true then
--             add_multiple_laboratories_M7(p_aantal_laboratories);
--             add_multiple_instruments_M7(p_aantal_c_instruments);
--             add_multiple_samples_M7(p_aantal_a_samples);
--             add_multiple_technicians_M7(p_aantal_b_technicians);
--             add_multiple_measurements_M7(p_aantal_d_measurements);
--         END IF;
--
--         ts2 := SYSTIMESTAMP;
--         DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
--                              'The duration of the total line generation was: ' || timestamp_diff(ts1, ts2) ||
--                              ' seconds');
--
--     END bewijs_milestone_M7_S1;

    PROCEDURE bewijs_milestone_M7_S1(p_aantal_a_samples  IN NUMERIC,p_aantal_b_technicians IN NUMERIC,
                                     p_aantal_c_instruments IN NUMERIC, p_aantal_d_measurements IN NUMERIC,p_aantal_laboratories IN NUMERIC,
                                     execute_M5 IN BOOLEAN)
    AS
        ts1          timestamp;
        ts2          timestamp;
        ts3          timestamp;
        ts4          timestamp;
        ts5          timestamp;
        ts6          timestamp;
    BEGIN
        empty_tables_S1();

        IF execute_M5 = true then --geen gebruik van bewijs_M5 wegens moeilijkheden met oproepen andere package.
            ts1 := SYSTIMESTAMP;
            add_multiple_laboratories_M7(p_aantal_laboratories);
            add_multiple_instruments_M7(p_aantal_c_instruments);
            add_multiple_samples_M7(p_aantal_a_samples);
            add_multiple_technicians_M7(p_aantal_b_technicians);
            add_multiple_measurements_M7(p_aantal_d_measurements);
            ts2 := SYSTIMESTAMP;

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                                 'The duration of the total line generation of M5-procedures was: ' ||
                                 abs(timestamp_diff(ts2, ts1)) ||
                                 ' seconds');
            empty_tables_S1();

        END IF;

        ts3 := systimestamp;

        add_multiple_laboratories_M7(p_aantal_laboratories);

        if execute_M5 = true
        then
            ts5 := SYSTIMESTAMP;
--             readd_M7();
            ts6 := SYSTIMESTAMP;
        end if;

        add_multiple_technicians_M7(p_aantal_b_technicians);
        add_multiple_samples_M7(p_aantal_a_samples);
        add_multiple_instruments_M7(p_aantal_c_instruments);
        add_multiple_measurements_M7(p_aantal_d_measurements);

        ts4 := SYSTIMESTAMP;
        DBMS_OUTPUT.PUT_LINE(
                    TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                    'The duration of the total line generation of M7-procedures was: ' ||
                    timestamp_diff(ts4, ts3) || ' seconds');
        If
                execute_M5 = true
        THEN
            DBMS_OUTPUT.PUT_LINE(
                        TO_CHAR(SYSTIMESTAMP, '[YYYY-MM-DD HH24:MI:SS]  ') ||
                        'The duration of the total line generation between M5 and M7 is: ' ||
                        (abs(timestamp_diff(ts2, ts1)) - abs(timestamp_diff(ts4, ts3)) + abs(timestamp_diff(ts6, ts5))) || ' seconds');
        END IF;


    END bewijs_milestone_M7_S1;


END PKG_S1_LABORATORIES;