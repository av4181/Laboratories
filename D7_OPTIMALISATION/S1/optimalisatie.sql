-- ALTER USER ADMIN QUOTA UNLIMITED ON DATA;

BEGIN
    PKG_S1_LABORATORIES.EMPTY_TABLES_S1();
    PKG_S1_LABORATORIES.bewijs_milestone_M7_S1(300,
                                                300,
                                                300,
                                                40000,
                                                300,
                                                false);
END;

-- Stats tabellen
BEGIN
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'LABORATORIES');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'SAMPLES');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'LAB_TECHNICIANS');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'INSTRUMENTS');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'MEASUREMENTS');
END;

-- Table size
SELECT segment_name, segment_type, sum(bytes/1024/1024) MB,
       (SELECT COUNT(*) FROM MEASUREMENTS)  as table_count
FROM DBA_SEGMENTS
WHERE SEGMENT_NAME = 'MEASUREMENTS'
GROUP BY segment_name, segment_type;

-- SELECT * FROM MEASUREMENTS;

-- SELECT * FROM SAMPLES;

-- Query voor alle metingen waarvoor de sample status gecancelled werd,
-- in de maand mei en uitgevoerd door laboranten id 10-20
-- Explain plan bijhouden
EXPLAIN PLAN FOR
SELECT l.Laboratory_Name, AVG(m.Measurement_Cost) AS avg_cost
FROM Laboratories l
         JOIN Lab_Technicians lt ON l.Laboratory_ID = lt.Laboratory_ID
         JOIN Measurements m ON lt.Technician_ID = m.Technician_ID
         JOIN Samples s ON m.Sample_ID = s.Sample_ID
WHERE s.Sample_Status = 'CANCELLED'
  AND m.Measurement_Start_Date BETWEEN TO_DATE('2024-05-01', 'YYYY-MM-DD') AND TO_DATE('2024-05-31', 'YYYY-MM-DD')
  AND lt.Technician_ID BETWEEN 10 AND 20
GROUP BY l.Laboratory_Name
ORDER BY avg_cost DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Besluiten
-- Full table scans op tabellen MEASUREMENTS, SAMPLES en LABORATORIES
-- Alle rijen worden dus doorzocht in die 3 tabellen
-- Overwegigingen :
--          - indexen creëeren op Sample_Status en Measurement_Start_Date
--          - Partitionering MEASUREMENTS op Measurement_Start_Date (datums worden nu generereert tot 10
--              dagen geleden)

-- Eerst alles terug droppen en nadien terug createn met de nodige partities en/of indexen
BEGIN
    PKG_S1_LABORATORIES.EMPTY_TABLES_S1();
end;

-- Grant privileges
-- GRANT ALTER SESSION TO ADMIN;
-- GRANT ALTER SYSTEM TO ADMIN;
-- GRANT ADMINISTER DATABASE TRIGGER TO ADMIN;
--
-- -- Verify privileges
-- SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'ADMIN' AND PRIVILEGE IN ('ALTER SESSION', 'ADMINISTER DATABASE TRIGGER');
-- alter session set "_partition_large_extents" = false;

-- Partitionering
DROP TABLE MEASUREMENTS CASCADE CONSTRAINTS PURGE;
CREATE TABLE Measurements (
                              Measurement_ID         INTEGER GENERATED ALWAYS AS IDENTITY,
                              Sample_ID              INTEGER       NOT NULL,
                              Instrument_ID          INTEGER       NOT NULL,
                              Technician_ID          INTEGER       NOT NULL,
                              Measurement_Start_Date TIMESTAMP,
                              Measurement_End_Date   TIMESTAMP,
                              Result                 NUMBER (10,2),
                              Unit                   VARCHAR(30),
                              Measurement_Cost       NUMBER(10,2) NOT NULL,
                              CONSTRAINT PK_MEASUREMENTS PRIMARY KEY (Measurement_ID),
                              CONSTRAINT Measurement_ck_2 CHECK ( Measurement_End_Date > Measurement_Start_Date ),
                              CONSTRAINT Measurement_ck_3 CHECK ( Result > 0 )
)
    PARTITION BY RANGE (Measurement_Start_Date)
    INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
    (
        PARTITION measurements_p0 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD'))
    )
;
-- Indexen --
DROP TABLE SAMPLES PURGE;

CREATE TABLE Samples
(
    Sample_ID          INTEGER GENERATED ALWAYS AS IDENTITY,
    Sample_Description VARCHAR(30) NOT NULL,
    Sample_Status      VARCHAR(30) NOT NULL,
    Sampling_Date      TIMESTAMP   NOT NULL,
    Samplepoint        VARCHAR(30) NOT NULL,
    Sample_Type        VARCHAR(30) NOT NULL,
    Product            VARCHAR(30) NOT NULL,
    CONSTRAINT PK_SAMPLE PRIMARY KEY (Sample_ID),
    CONSTRAINT Sample_ck_1 CHECK ( length(SAMPLE_DESCRIPTION) >= 3 ),
    CONSTRAINT Sample_ck_2 CHECK ( length(SAMPLE_STATUS) >= 2 )
);
-- CREATE INDEX idx_samples_sample_status ON Samples(Sample_Status);

DROP TABLE INSTRUMENTS;

CREATE TABLE Instruments
(
    Instrument_ID          INTEGER GENERATED ALWAYS AS IDENTITY,
    Instrument_Description VARCHAR(30) not null,
    Instrument_Name        VARCHAR(30) NOT NULL,
    Instrument_Cost        VARCHAR(30) NOT NULL,
    CONSTRAINT INSTRUMENT_ID PRIMARY KEY (Instrument_ID),
    CONSTRAINT Instrument_ck_1 CHECK ( length(INSTRUMENT_DESCRIPTION) >= 3 ),
    CONSTRAINT Instrument_ck_2 CHECK ( Instrument_Cost LIKE '%€%')
);

DROP TABLE  LAB_TECHNICIANS;

CREATE TABLE Lab_Technicians
(
    Technician_ID       INTEGER GENERATED ALWAYS AS IDENTITY,
    Laboratory_ID       INTEGER                          NOT NULL,
    Supervisor_ID       INTEGER,
    First_Name          VARCHAR(30)                      NOT NULL,
    Last_Name           VARCHAR(30)                      NOT NULL,
    Gender              CHAR                             NOT NULL,
    Function            VARCHAR(30) DEFAULT 'Technician' NOT NULL,
    Function_Start_Date DATE                             NOT NULL,
    Function_End_Date   DATE,
    CONSTRAINT TECHNICIAN_ID_PK PRIMARY KEY (Technician_ID),
    CONSTRAINT Lab_Technician_ck_Dates CHECK (Function_End_Date > Function_Start_Date),
    CONSTRAINT Lab_Technician_ck_Gender CHECK ( Gender IN ('M', 'V') )
);
--     PARTITION BY RANGE (Technician_ID)  -- Partitie op Technician_ID
--     INTERVAL (10)
-- (
--     PARTITION lab_technicians_p0 VALUES LESS THAN (10)
-- --     PARTITION lab_technicians_p1 VALUES LESS THAN (20),
-- --     PARTITION lab_technicians_p2 VALUES LESS THAN (30),
-- --     PARTITION lab_technicians_p3 VALUES LESS THAN (40),
-- --     PARTITION lab_technicians_p4 VALUES LESS THAN (50),
-- --     PARTITION lab_technicians_p5 VALUES LESS THAN (60),
-- --     PARTITION lab_technicians_p6 VALUES LESS THAN (70),
-- --     PARTITION lab_technicians_p7 VALUES LESS THAN (80),
-- --     PARTITION lab_technicians_p8 VALUES LESS THAN (90),
-- --     PARTITION lab_technicians_p9 VALUES LESS THAN (100),
-- --     PARTITION lab_technicians_p10 VALUES LESS THAN (110),
-- --     PARTITION lab_technicians_p11 VALUES LESS THAN (120),
-- --     PARTITION lab_technicians_p12 VALUES LESS THAN (130),
-- --     PARTITION lab_technicians_p13 VALUES LESS THAN (140),
-- --     PARTITION lab_technicians_p14 VALUES LESS THAN (150),
-- --     PARTITION lab_technicians_p15 VALUES LESS THAN (160),
-- --     PARTITION lab_technicians_p16 VALUES LESS THAN (170),
-- --     PARTITION lab_technicians_p17 VALUES LESS THAN (180),
-- --     PARTITION lab_technicians_p18 VALUES LESS THAN (190),
-- --     PARTITION lab_technicians_p19 VALUES LESS THAN (200),
-- --     PARTITION lab_technicians_p20 VALUES LESS THAN (210),
-- --     PARTITION lab_technicians_p21 VALUES LESS THAN (220),
-- --     PARTITION lab_technicians_p22 VALUES LESS THAN (230),
-- --     PARTITION lab_technicians_p23 VALUES LESS THAN (240),
-- --     PARTITION lab_technicians_p24 VALUES LESS THAN (250),
-- --     PARTITION lab_technicians_p25 VALUES LESS THAN (260),
-- --     PARTITION lab_technicians_p26 VALUES LESS THAN (270),
-- --     PARTITION lab_technicians_p27 VALUES LESS THAN (280),
-- --     PARTITION lab_technicians_p30 VALUES LESS THAN (290),
-- --     PARTITION lab_technicians_p31 VALUES LESS THAN (300)
-- )

DROP TABLE LABORATORIES;

CREATE TABLE Laboratories
(
    Laboratory_ID            INTEGER GENERATED ALWAYS AS IDENTITY,
    Laboratory_Name          VARCHAR(50)  NOT NULL,
    Laboratory_Description   VARCHAR(255),
    Laboratory_Street_Number numeric(3)   NOT NULL,
    Laboratory_Street        VARCHAR(50)  NOT NULL,
    Laboratory_Location      VARCHAR(100) NOT NULL,
    Company                  VARCHAR(50)  NOT NULL,
    CONSTRAINT PK_LABORATORY PRIMARY KEY (Laboratory_ID)
);
ALTER TABLE Lab_Technicians
    ADD CONSTRAINT LABORATORY_LAB_TECHNICIANS_FK
        FOREIGN KEY (Laboratory_ID)
            REFERENCES Laboratories (Laboratory_ID)
                DEFERRABLE
    ADD CONSTRAINT LABTECHNICIANS_LABTECHNICIA461
        FOREIGN KEY (Supervisor_ID)
            REFERENCES Lab_Technicians (Technician_ID)
                DEFERRABLE;
ALTER TABLE Measurements
    ADD CONSTRAINT TECHNIQUE_MEASUREMENT_FK
        FOREIGN KEY (Instrument_ID)
            REFERENCES Instruments (Instrument_ID)
                NOT DEFERRABLE
    ADD CONSTRAINT SAMPLE_MEASUREMENT_FK
        FOREIGN KEY (Sample_ID)
            REFERENCES Samples (Sample_ID)
                ON DELETE CASCADE
                NOT DEFERRABLE
    ADD CONSTRAINT LABTECHNICIANS_MEASUREMENT_FK
        FOREIGN KEY (Technician_ID)
            REFERENCES Lab_Technicians (Technician_ID)
                NOT DEFERRABLE;

--  Alles opnieuw opvullen
BEGIN
    PKG_S1_LABORATORIES.bewijs_milestone_M7_S1(3000,
                                               3000,
                                               3000,
                                               40000,
                                               3000,
                                               true);
END;
-- Stats ophalen
BEGIN
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'LABORATORIES');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'SAMPLES');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'LAB_TECHNICIANS');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'INSTRUMENTS');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'MEASUREMENTS');
END;

-- Check Table size
SELECT segment_name, segment_type, sum(bytes/1024/1024) MB,
       (SELECT COUNT(*) FROM MEASUREMENTS)  as table_count
FROM DBA_SEGMENTS
WHERE SEGMENT_NAME = 'MEASUREMENTS'
GROUP BY segment_name, segment_type;

-- Query nog eens herhalen
EXPLAIN PLAN FOR
SELECT l.Laboratory_Name, AVG(m.Measurement_Cost) AS avg_cost
FROM Laboratories l
         JOIN Lab_Technicians lt ON l.Laboratory_ID = lt.Laboratory_ID
         JOIN Measurements m ON lt.Technician_ID = m.Technician_ID
         JOIN Samples s ON m.Sample_ID = s.Sample_ID
WHERE s.Sample_Status = 'CANCELLED'
  AND m.Measurement_Start_Date BETWEEN TO_DATE('2024-05-01', 'YYYY-MM-DD') AND TO_DATE('2024-05-31', 'YYYY-MM-DD')
  AND lt.Technician_ID BETWEEN 10 AND 20
GROUP BY l.Laboratory_Name
ORDER BY avg_cost DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Check aantal en grootte partities:
select * from LAB_TECHNICIANS;
SELECT PARTITION_NAME, HIGH_VALUE, BLOCKS
FROM ALL_TAB_PARTITIONS
WHERE TABLE_OWNER='PROJECT';

-- Check block size:
select block_size, tablespace_name from dba_tablespaces;

-- Check indices:
SELECT INDEX_NAME, TABLE_NAME, TABLE_OWNER
FROM ALL_INDEXES
WHERE TABLE_NAME = 'SAMPLES' AND INDEX_NAME = 'idx_samples_sample_status';

SELECT INDEX_NAME, COLUMN_NAME, COLUMN_POSITION
FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'SAMPLES' AND INDEX_NAME = 'idx_samples_sample_status';

EXPLAIN PLAN FOR
SELECT * FROM SAMPLES WHERE Sample_Status = 'CANCELLED';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
