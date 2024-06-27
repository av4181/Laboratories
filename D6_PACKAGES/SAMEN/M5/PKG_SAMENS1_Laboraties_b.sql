create PACKAGE BODY PKG_SAMENS1_M5_LABORATORIES
AS
    --EMPTY TABLES--
    PROCEDURE empty_tables_S1
    AS
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE MEASUREMENTS';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE LAB_TECHNICIANS';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE INSTRUMENTS';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE SAMPLES';

        EXECUTE IMMEDIATE 'ALTER TABLE INSTRUMENTS MODIFY INSTRUMENT_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE SAMPLES MODIFY SAMPLE_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE LAB_TECHNICIANS MODIFY TECHNICIAN_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE MEASUREMENTS MODIFY MEASUREMENT_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';

    END empty_tables_S1;
-------------------------------
-- PRIVATE FUNCTIES --
-------------------------------
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

    --ADD PROCEDURES--
    PROCEDURE add_lab_technician(
        p_first_name IN Lab_Technicians.First_Name%TYPE,
        p_last_name IN Lab_Technicians.Last_Name%TYPE,
        p_gender IN Lab_Technicians.Gender%TYPE,
        p_function IN Lab_Technicians.Function%TYPE,
        p_start_date IN Lab_Technicians.Function_Start_Date%TYPE,
        p_end_date IN Lab_Technicians.Function_End_Date%TYPE,
        p_laboratory_name IN Laboratories.Laboratory_Name%TYPE)
    AS
        v_laboratory LABORATORIES.LABORATORY_ID%TYPE := lookup_laboratory(p_laboratory_name);
    BEGIN
        INSERT INTO Lab_Technicians (Laboratory_ID,
                                     First_Name,
                                     Last_Name,
                                     Gender,
                                     "FUNCTION",
                                     Function_Start_Date,
                                     Function_End_Date)
        VALUES (v_laboratory,
                p_first_name,
                p_last_name,
                p_gender,
                p_function,
                p_start_date,
                p_end_date);
    END add_lab_technician;

    PROCEDURE add_instrument(
        p_instrument_description IN Instruments.Instrument_Description%TYPE,
        p_instrument_name IN Instruments.Instrument_Name%TYPE,
        p_cost IN Instruments.Instrument_Cost%TYPE)
    AS
    BEGIN
        INSERT INTO Instruments (Instrument_Description,
                                 Instrument_Name,
                                 Instrument_Cost)
        VALUES (p_instrument_description,
                p_instrument_name,
                p_cost);
    END add_instrument;

    PROCEDURE add_sample(
        p_sample_description IN Samples.Sample_Description%TYPE,
        p_sample_status IN Samples.Sample_Status%TYPE,
        p_sampling_date IN Samples.Sampling_Date%TYPE,
        p_sample_point IN Samples.Samplepoint%TYPE,
        p_sample_type IN Samples.Sample_Type%TYPE,
        p_product IN Samples.Product%TYPE)
    AS
    BEGIN
        INSERT INTO Samples (Sample_Description,
                             Sample_Status,
                             Sampling_Date,
                             Samplepoint,
                             Sample_Type,
                             Product)
        VALUES (p_sample_description,
                p_sample_status,
                p_sampling_date,
                p_sample_point,
                p_sample_type,
                p_product);
    END add_sample;

    PROCEDURE add_measurement(
        p_start_date IN Measurements.Measurement_Start_Date%TYPE,
        p_end_date IN Measurements.Measurement_End_Date%TYPE,
        p_result IN Measurements.Result%TYPE,
        p_unit IN Measurements.Unit%TYPE,
        p_cost IN Measurements.Measurement_Cost%TYPE,
        --p_laboratory_name IN Laboratories.LABORATORY_NAME%TYPE,
        p_sample_description IN Samples.Sample_Description%TYPE,
        p_instrument_description IN Instruments.INSTRUMENT_DESCRIPTION%TYPE,
        p_technician_first_name IN Lab_technicians.First_Name%TYPE,
        p_technician_last_name IN Lab_technicians.Last_Name%TYPE)
    AS
        --v_laboratory LABORATORIES.LABORATORY_ID%TYPE:= lookup_laboratory(p_laboratory_name);
        v_sample     SAMPLES.SAMPLE_ID%TYPE             := lookup_sample(p_sample_description);
        v_instrument INSTRUMENTs.INSTRUMENT_ID%TYPE     := lookup_instrument(p_instrument_description);
        v_technician LAB_TECHNICIANS.TECHNICIAN_ID%TYPE := lookup_lab_technician(p_technician_first_name,
                                                                                 p_technician_last_name);
    BEGIN
        INSERT INTO Measurements (Sample_ID,
                                  Instrument_ID,
                                  Technician_ID,
                                  Measurement_Start_Date,
                                  Measurement_End_Date,
                                  Result,
                                  Unit,
                                  Measurement_Cost)
        VALUES (v_sample,
                v_instrument,
                v_technician,
                p_start_date,
                p_end_date,
                p_result,
                p_unit,
                p_cost);
    END add_measurement;

--Function SAMEN

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
        EXECUTE IMMEDIATE 'TRUNCATE TABLE LABORATORIES';
        EXECUTE IMMEDIATE 'ALTER TABLE LABORATORIES MODIFY LABORATORY_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        --truncates in case tabellen niet leeg zijn.
        --laboratories nodig voor Lab_technicians's FK's.

        PKG_SAMENS2_M5_LABORATORIES.ADD_LABORATORY_SAMEN();

        add_instrument('Chromotography', 'GE Multiskan', '€500');
        add_instrument('Spectroscopy', 'Siemens Spectro', '€1100');
        add_instrument('Calory', 'ABB XL', '€105');
        add_instrument('Luminometer', 'Lumac', '€805');
        add_instrument('pH Measurement', 'Hach Lange', '€125');
        --add_instrument('pH Measurement', 'Hach Lange', '€125');

        add_sample('Tank B600', 'SHIPPED', '20/10/22 10:35:00', 'QT501010', 'inline', 'benzene');
        add_sample('Water Treatment', 'CANCELLED', '03/01/23 10:35:00', 'QI10005', 'probe', 'water');
        add_sample('Extruder', 'FINAL', '08/01/20 08:15:11', 'Q123456', 'QA', 'polymer');
        add_sample('Flare', 'FINAL', '30/03/24 09:54:00', 'QIC65124', 'Emissions', 'VOC');
        add_sample('Ship Unloading', 'SHIPPED', '01/12/22 15:26:01', 'Q789456', 'Imports', 'nafta');

        add_lab_technician('Bruno', 'Willems', 'M', 'Manager', TO_DATE('29/09/05', 'DD/MM/YYYY'), NULL, 'VITO');
        add_lab_technician('An', 'Jacobs', 'V', 'Technician', TO_DATE('15/01/2010', 'DD/MM/YYYY'), NULL, 'UZA');
        add_lab_technician('Katrien', 'Wauters', 'V', 'Technician', TO_DATE('10/07/1978', 'DD/MM/YYYY'), NULL, 'UZA');
        add_lab_technician('Tom', 'Peeters', 'M', 'Shiftleader', TO_DATE('01/11/1982', 'DD/MM/YYYY'), NULL,
                           'Klinisch labo AZM');
        add_lab_technician('Inge', 'De Smet', 'V', 'Technician', TO_DATE('01/02/1999', 'DD/MM/YYYY'), NULL, 'UZA');

        add_measurement('01/02/22 10:00:00',
                        '01/02/22 12:00:00',
                        500,
                        'ppm',
                        95,
            --'UZA',
                        'Water Treatment',
                        'pH Measurement',
                        'An',
                        'Jacobs');
        add_measurement('05/03/23 16:00:00',
                        '06/03/23 09:00:00',
                        7.1,
                        'pH',
                        70,
            --'Klinisch labo AZM',
                        'Water Treatment',
                        'pH Measurement',
                        'Tom',
                        'Peeters');
        add_measurement('01/10/19 15:00:00',
                        '02/10/19 16:00:00',
                        20,
                        'wt-%',
                        205,
            --'UZA',
                        'Water Treatment',
                        'Spectroscopy',
                        'An',
                        'Jacobs');
        add_measurement('11/11/15 10:00:00',
                        '11/11/15 13:00:00',
                        40000,
                        'kJ/kg',
                        95,
            --'UZA',
                        'Flare',
                        'Calory',
                        'Katrien',
                        'Wauters');
        add_measurement('30/08/21 11:00:00',
                        '01/09/21 13:00:00',
                        10,
                        'wt-%',
                        205,
            --'UZA',
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
        TYPE t_tab_instruments IS VARRAY(5) OF INSTRUMENTS.INSTRUMENT_DESCRIPTION%TYPE;
        t_description        t_tab_instruments := t_tab_instruments('Chromotography',
                                                                    'Spectroscopy',
                                                                    'Calory',
                                                                    'Luminometer',
                                                                    'pH Measurement');
        v_description_picker NUMERIC           := random_number(1, t_description.COUNT);
    BEGIN
        return t_description(v_description_picker);
    END random_instrument_description;

    FUNCTION random_instrument_name
        RETURN INSTRUMENTS.INSTRUMENT_NAME%TYPE
    AS
        TYPE t_tab_instrument_name IS TABLE OF INSTRUMENTS.INSTRUMENT_NAME%TYPE;
        t_instrument_name        t_tab_instrument_name := t_tab_instrument_name('GE',
                                                                                'Siemens',
                                                                                'ABB',
                                                                                'Lumac',
                                                                                'Hach Lange');
        v_instrument_name_picker NUMERIC               := random_number(1, t_instrument_name.COUNT);
        v_random_number          NUMERIC(6)            := FLOOR(random_number(100000, 999999));
    BEGIN
        RETURN t_instrument_name(v_instrument_name_picker) || '_' || TO_CHAR(v_random_number);
    END random_instrument_name;

    -- Lab_technicians --
    FUNCTION random_function
        RETURN LAB_TECHNICIANS.FUNCTION%TYPE
        IS
        TYPE type_varray_type IS VARRAY(3) OF VARCHAR2(50);
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
                                                               'Leen', 'Regina', 'Jan-Willem', 'Jef', 'Nik',
                                                               'Dominique',
                                                               'Tim', 'Tinne', 'Cloe', 'Katrien', 'Els', 'Constant',
                                                               'Jacques',
                                                               'Dirk', 'Thierry', 'Wendy', 'Sarah', 'Annie', 'Jean',
                                                               'Jack',
                                                               'Jonas', 'Eline', 'Nils', 'Robin', 'Theo', 'Sabine');

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
                                                            'Meijer', 'De Groot', 'Visser', 'Bos', 'Mulder', 'De Wit',
                                                            'Peters', 'Hendriks', 'Van Leeuwen', 'Dekker', 'Brouwer',
                                                            'De Haan', 'Van den Bosch', 'Sanders', 'De Vos',
                                                            'Van der Linden',
                                                            'De Bruijn', 'Van den Broek', 'Van de Ven', 'Groen',
                                                            'Van der Heijden', 'De Bruin', 'Bakker', 'Verbeek',
                                                            'Van Loon',
                                                            'Willemsen', 'Timmermans', 'Van de Velde', 'Van den Heuvel',
                                                            'De Graaf', 'Blom', 'Kramer', 'De Leeuw', 'Kuipers',
                                                            'Van der Molen',
                                                            'Van der Velden', 'Hermans', 'Martens');

    BEGIN
        RETURN t_lastname(random_number(1, t_lastname.COUNT));
    END random_lastname;

    FUNCTION random_gender
        RETURN LAB_TECHNICIANS.GENDER%TYPE
        IS
        TYPE type_varray_type IS VARRAY(5) OF VARCHAR2(50);
        t_type type_varray_type := type_varray_type('M', 'V', 'X');
    BEGIN
        RETURN t_type(random_number(1, t_type.COUNT));
    END random_gender;

    -- Laboratory --
    -- TODO random_lab_description
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

    -- Sample--
    FUNCTION random_sample_description
        RETURN SAMPLES.SAMPLE_DESCRIPTION%TYPE
    AS
        TYPE t_tab_sample_description IS TABLE OF INSTRUMENTS.INSTRUMENT_NAME%TYPE;
        t_sample_description        t_tab_sample_description := t_tab_sample_description('Tank B',
                                                                                         'Column C',
                                                                                         'Vessel V',
                                                                                         'Flare F',
                                                                                         'Extruder E');
        v_sample_description_picker NUMERIC                  := random_number(1, t_sample_description.COUNT);
        v_random_number             NUMERIC(6)               := FLOOR(random_number(1000, 9999));
    BEGIN
        RETURN t_sample_description(v_sample_description_picker) || '' || TO_CHAR(v_random_number);
    END random_sample_description;


    FUNCTION random_sample_status
        RETURN SAMPLES.SAMPLE_STATUS%TYPE
        IS
        TYPE type_varray_type IS VARRAY(5) OF VARCHAR2(50);
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
        t_original_amount_technicians LAB_TECHNICIANS.TECHNICIAN_ID%TYPE;
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
        t_original_amount_instruments INSTRUMENTS.INSTRUMENT_ID%TYPE;
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
        t_original_amount_samples SAMPLES.SAMPLE_ID%TYPE;
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
        t_original_amount_measurements MEASUREMENTS.MEASUREMENT_ID%TYPE;
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
        add_random_laboratory(20);
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
                             'The duration of the total line generation was: ' || timestamp_diff(ts1, ts2) ||
                             ' seconds');

    END bewijs_milestone_M5_S1;

END PKG_SAMENS1_M5_LABORATORIES;
/

