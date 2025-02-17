-- Generated by SQL Power Architect 1.0.9
-- Modified manually for contraints, datatypes, identities

DROP TABLE Measurements PURGE;
DROP TABLE Lab_Technicians PURGE;
DROP TABLE Samples PURGE;
DROP TABLE Instruments PURGE;
DROP TABLE Laboratories PURGE;


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

CREATE TABLE Measurements (
                             Measurement_ID         INTEGER GENERATED ALWAYS AS IDENTITY,
                             Sample_ID              INTEGER NOT NULL,
                             Instrument_ID          INTEGER NOT NULL,
                             Technician_ID          INTEGER NOT NULL,
                             Measurement_Start_Date TIMESTAMP,
                             Measurement_End_Date TIMESTAMP,
                             Result NUMBER (10,2),
                             Unit VARCHAR(30),
                             Measurement_Cost NUMBER(10,2) NOT NULL,
                             CONSTRAINT PK_MEASUREMENTS PRIMARY KEY (Measurement_ID),
                             CONSTRAINT Measurement_ck_2 CHECK ( Measurement_End_Date > Measurement_Start_Date ),
                             CONSTRAINT Measurement_ck_3 CHECK ( Result > 0 )
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
--NOT DEFERRABLE


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
                NOT DEFERRABLE