-- Laboratory
INSERT INTO Laboratories
    (Laboratory_Name, Company, Laboratory_Street,LABORATORY_STREET_NUMBER, Laboratory_Description, Laboratory_Location)
VALUES ('VITO', 'Overheid', 'BOERETANG', 200 , 'Labo voor grondstalen', 'Mol');
INSERT INTO Laboratories
(Laboratory_Name, Company, Laboratory_Street,LABORATORY_STREET_NUMBER, Laboratory_Description, Laboratory_Location)
VALUES ('UZA', 'Overheid', 'DRIE EIKENSTRAAT', 655 , 'Chemie', 'Edegem');
INSERT INTO Laboratories
(Laboratory_Name, Company, Laboratory_Street,LABORATORY_STREET_NUMBER, Laboratory_Description, Laboratory_Location)
VALUES ('AZ Voorkempen', 'Overheid', 'OUDE LIERSEBAAN', 4 , 'Microbiologie', 'Malle');
INSERT INTO Laboratories
(Laboratory_Name, Company, Laboratory_Street,LABORATORY_STREET_NUMBER, Laboratory_Description, Laboratory_Location)
VALUES ('Klinisch labo AZM', 'Overheid', 'FLORENT PAUWELSLEI', 1 , 'Toxicologie', 'Deurne');
INSERT INTO Laboratories
(Laboratory_Name, Company, Laboratory_Street,LABORATORY_STREET_NUMBER, Laboratory_Description, Laboratory_Location)
VALUES ('Instituut voor tropische geneeskunde', 'Overheid', 'KRONENBURGSTRAAT', 433, 'Toxicologie', 'Deurne');

-- Instrument
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

-- Sample
INSERT INTO Samples(Sample_Description,Sample_Status, Sampling_Date, Samplepoint, Sample_Type, Product)
VALUES ('Tank B600','SHIPPED', '20/10/22 10:35:00', 'QT501010', 'inline', 'benzene');
INSERT INTO Samples(Sample_Description,Sample_Status, Sampling_Date, Samplepoint, Sample_Type, Product)
VALUES ('Water Treatment','CANCELLED', '03/01/23 10:35:00', 'QI10005', 'probe', 'water');
INSERT INTO Samples(Sample_Description,Sample_Status, Sampling_Date, Samplepoint, Sample_Type, Product)
VALUES ('Extruder','FINAL', '08/01/20 08:15:11', 'Q123456', 'QA', 'polymer');
INSERT INTO Samples(Sample_Description,Sample_Status, Sampling_Date, Samplepoint, Sample_Type, Product)
VALUES ('Flare','FINAL', '30/03/24 09:54:00', 'QIC65124', 'Emissions', 'VOC');
INSERT INTO Samples(Sample_Description,Sample_Status, Sampling_Date, Samplepoint, Sample_Type, Product)
VALUES ('Ship Unloading','SHIPPED', '01/12/22 15:26:01', 'Q789456', 'Imports', 'nafta');

-- Lab_Technicians
INSERT INTO Lab_Technicians
    (Laboratory_ID, Supervisor_ID, First_Name, Last_Name, Gender, Function, Function_Start_Date, Function_End_Date)
VALUES((SELECT Laboratory_ID FROM Laboratories WHERE Laboratory_Name = 'VITO'),
       NULL,
       'Bruno','Willems','M','Manager',TO_DATE('29/09/05','DD/MM/YYYY'),NULL);

INSERT INTO Lab_Technicians
(Laboratory_ID, Supervisor_ID, First_Name, Last_Name, Gender, Function, Function_Start_Date, Function_End_Date)
VALUES((SELECT Laboratory_ID FROM Laboratories WHERE Laboratory_Name = 'UZA'),
       NULL,
       'An','Jacobs','V','Technician',TO_DATE('15/01/2010','DD/MM/YYYY'),NULL);

INSERT INTO Lab_Technicians
(Laboratory_ID, Supervisor_ID, First_Name, Last_Name, Gender, Function, Function_Start_Date, Function_End_Date)
VALUES((SELECT Laboratory_ID FROM Laboratories WHERE Laboratory_Name = 'UZA'),
       NULL,
       'Katrien','Wauters','V','Technician',TO_DATE('10/07/1978','DD/MM/YYYY'),NULL);

INSERT INTO Lab_Technicians
(Laboratory_ID, Supervisor_ID, First_Name, Last_Name, Gender, Function, Function_Start_Date, Function_End_Date)
VALUES((SELECT Laboratory_ID FROM Laboratories WHERE Laboratory_Name = 'Klinisch labo AZM'),
       NULL,'Tom','Peeters','M','Shiftleader',TO_DATE('01/11/1982','DD/MM/YYYY'),NULL);

INSERT INTO Lab_Technicians
(Laboratory_ID, Supervisor_ID, First_Name, Last_Name, Gender, Function, Function_Start_Date, Function_End_Date)
VALUES((SELECT Laboratory_ID FROM Laboratories WHERE Laboratory_Name = 'VITO'),
       NULL,
       'Inge','De Smet','V','Technician',TO_DATE('01/02/1999','DD/MM/YYYY'),NULL);

UPDATE Lab_Technicians
SET Supervisor_ID = (SELECT TECHNICIAN_ID FROM Lab_Technicians WHERE FIRST_NAME = 'Tom' and LAST_NAME = 'Peeters')
WHERE First_Name = 'An' AND LAST_NAME = 'Jacobs';

UPDATE Lab_Technicians
SET Supervisor_ID = (SELECT TECHNICIAN_ID FROM Lab_Technicians WHERE FIRST_NAME = 'Tom' and LAST_NAME = 'Peeters')
WHERE First_Name = 'Katrien' AND LAST_NAME = 'Wauters';

UPDATE Lab_Technicians
SET Supervisor_ID = (SELECT TECHNICIAN_ID FROM Lab_Technicians WHERE FIRST_NAME = 'Bruno' and LAST_NAME = 'Willems')
WHERE First_Name = 'Tom' AND LAST_NAME = 'Peeters';

UPDATE Lab_Technicians
SET Supervisor_ID = (SELECT TECHNICIAN_ID FROM Lab_Technicians WHERE FIRST_NAME = 'Tom' and LAST_NAME = 'Peeters')
WHERE First_Name = 'Inge' AND LAST_NAME = 'De Smet';

-- Measurement
INSERT INTO Measurements
    (Sample_ID, Instrument_ID, Technician_ID, Measurement_Start_Date, Measurement_End_Date,Result, Unit, Measurement_Cost)
VALUES (
        (SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Water Treatment'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'pH Measurement'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'An' and LAST_NAME = 'Jacobs'),
        '01/02/22 10:00:00',
        '01/02/22 12:00:00',
        500,
        'ppm',
        95);

INSERT INTO Measurements
(Sample_ID, Instrument_ID, Technician_ID, Measurement_Start_Date, Measurement_End_Date,Result, Unit, Measurement_Cost)
VALUES (
        (SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Water Treatment'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'pH Measurement'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'Tom' and LAST_NAME = 'Peeters'),
        '05/03/23 16:00:00',
        '06/03/23 09:00:00',
        7.1,
        'pH',
        70);

INSERT INTO Measurements
(Sample_ID, Instrument_ID, Technician_ID, Measurement_Start_Date, Measurement_End_Date,Result, Unit, Measurement_Cost)
VALUES (
        (SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Water Treatment'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'Spectroscopy'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'An' and LAST_NAME = 'Jacobs'),
        '01/10/19 15:00:00',
        '02/10/19 16:00:00',
        20,
        'wt-%',
        205);

INSERT INTO Measurements
(Sample_ID, Instrument_ID, Technician_ID, Measurement_Start_Date, Measurement_End_Date,Result, Unit, Measurement_Cost)
VALUES (
        (SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Flare'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'Calory'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'Katrien' and LAST_NAME = 'Wauters'),
        '11/11/15 10:00:00',
        '11/11/15 13:00:00',
        40000,
        'kJ/kg',
        95);

INSERT INTO Measurements
(Sample_ID, Instrument_ID, Technician_ID, Measurement_Start_Date, Measurement_End_Date,Result, Unit, Measurement_Cost)
VALUES (
        (SELECT SAMPLE_ID FROM SAMPLES WHERE SAMPLE_DESCRIPTION = 'Extruder'),
        (select INSTRUMENT_ID from INSTRUMENTS where INSTRUMENT_DESCRIPTION = 'Spectroscopy'),
        (select TECHNICIAN_ID from LAB_TECHNICIANS where FIRST_NAME = 'Katrien' and LAST_NAME = 'Wauters'),
        '30/08/21 11:00:00',
        '01/09/21 13:00:00',
        10,
        'wt-%',
        205);

