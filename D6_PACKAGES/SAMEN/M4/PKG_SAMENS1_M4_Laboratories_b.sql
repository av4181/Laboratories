create PACKAGE BODY PKG_SAMENS1_M4_LABORATORIES
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
    PROCEDURE bewijs_Milestone_M4_S1
    AS
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE LABORATORIES';
        EXECUTE IMMEDIATE 'ALTER TABLE LABORATORIES MODIFY LABORATORY_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        --truncates in case tabellen niet leeg zijn.
        --laboratories nodig voor Lab_technicians's FK's.

        PKG_SAMENS2_M4_LABORATORIES.ADD_LABORATORY_SAMEN();

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

END PKG_SAMENS1_M4_LABORATORIES;
/

