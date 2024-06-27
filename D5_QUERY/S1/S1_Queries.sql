-- table count
SELECT 'S1 B - Laboratories' AS table_name, (SELECT COUNT(*) FROM Laboratories) AS table_count
FROM dual
UNION
SELECT 'S1 A - Samples', (SELECT COUNT(*) FROM Samples)
FROM dual
UNION
SELECT 'S1 C - Lab Technicians', (SELECT COUNT(*) FROM Lab_Technicians)
FROM dual
UNION
SELECT 'S1 C - Measurements', (SELECT COUNT(*) FROM Measurements)
FROM dual
UNION
SELECT 'S1 D - Instruments', (SELECT COUNT(*) FROM Instruments) FROM dual;

-- veel op veel relatie

SELECT LABORATORY_NAME, LABORATORY_DESCRIPTION,SAMPLE_DESCRIPTION,FIRST_NAME, LAST_NAME
FROM Laboratories l
    JOIN LAB_TECHNICIANS lt on l.LABORATORY_ID = lt.LABORATORY_ID
    JOIN MEASUREMENTS m on lt.TECHNICIAN_ID = m.TECHNICIAN_ID
    JOIN SAMPLES s on m.SAMPLE_ID = s.SAMPLE_ID;

-- niet eerder getoonde tabellen
SELECT MEASUREMENT_ID,MEASUREMENT_START_DATE, MEASUREMENT_END_DATE, FIRST_NAME, LAST_NAME, INSTRUMENT_DESCRIPTION, INSTRUMENT_COST
FROM MEASUREMENTS m
        JOIN LAB_TECHNICIANS lt ON lt.TECHNICIAN_ID=m.TECHNICIAN_ID
        JOIN INSTRUMENTS i on m.INSTRUMENT_ID = i.INSTRUMENT_ID

ORDER BY MEASUREMENT_START_DATE;

-- Constraints M2
-- Measurement: Measurement_End_Date > Measurement_Start_Date
INSERT INTO Measurements
(Sample_ID, Instrument_ID, Technician_ID, Measurement_Start_Date, Measurement_End_Date,Result, Unit, Measurement_Cost)
VALUES (5,3,3, '30/10/21 11:00:00', '01/09/21 13:00:00', 10, 'wt-%', 205);

-- Measurement: Result > 0
INSERT INTO Measurements
(Sample_ID, Instrument_ID, Technician_ID, Measurement_Start_Date, Measurement_End_Date,Result, Unit, Measurement_Cost)
VALUES (4,4,3, '11/11/15 10:00:00','11/11/15 13:00:00', -5, 'kJ/kg', 95);


-- Sample: Description - minimum 3 characters
INSERT INTO Samples(Sample_Description,Sample_Status, Sampling_Date, Samplepoint, Sample_Type, Product)
VALUES ('XX','SHIPPED', '01/12/22 15:26:01', 'Q789456', 'Imports', 'nafta');

-- Sample: Status - minimum 2 characters
INSERT INTO Samples(Sample_Description,Sample_Status, Sampling_Date, Samplepoint, Sample_Type, Product)
VALUES ('Flare','A', '30/03/24 09:54:00', 'QIC65124', 'Emissions', 'VOC');

-- Instrument: Instrument_Description - minimum 3 characters
INSERT INTO INSTRUMENTS(Instrument_Description, Instrument_Name, Instrument_Cost)
VALUES ('XX', 'GE Multiskan', '€500');

-- Instrument: Instrument_Cost - must contain €
INSERT INTO INSTRUMENTS(Instrument_Description, Instrument_Name, Instrument_Cost)
VALUES ('Luminometer', 'Lumac', '805');

-- Lab_Technician: gender - M/V
INSERT INTO Lab_Technicians
(Laboratory_ID, Supervisor_ID, First_Name, Last_Name, Gender, Function, Function_Start_Date, Function_End_Date)
VALUES(3,NULL,'Inge','De Smet','Z','Teamleader',TO_DATE('01/02/1999','DD/MM/YYYY'),NULL);

-- Lab_Technician: Function_End_Date > Function_Start_Date
INSERT INTO Lab_Technicians
(Laboratory_ID, Supervisor_ID, First_Name, Last_Name, Gender, Function, Function_Start_Date, Function_End_Date)
VALUES(3,NULL,'Bruno','Willems','M','Manager',TO_DATE('01/11/1992','DD/MM/YYYY'),TO_DATE('01/11/1982','DD/MM/YYYY'));