--Drop if needed
--PURGE option behouden ==> Anders opstapelling van System-sequences (=Identity column) die niet gedropt kunnen worden.
DROP TABLE MEASUREMENTS PURGE;
DROP TABLE REPORTS PURGE;
DROP TABLE CAMPAIGNS PURGE;
DROP TABLE CONTACTS PURGE;
DROP TABLE INSTRUMENTS PURGE;
DROP TABLE SAMPLES PURGE;
DROP TABLE LAB_TECHNICIANS PURGE;
DROP TABLE LABORATORIES PURGE;

--S1 tabellen
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

--S2 tabellen

CREATE TABLE Contacts
(
    Person_ID   INTEGER GENERATED ALWAYS AS IDENTITY, --aangepast naar integer
    First_Name  VARCHAR(30) NOT NULL,
    Last_Name   VARCHAR(50) NOT NULL,
    Middle_Name VARCHAR(50),
    Email       VARCHAR(255),
    CONSTRAINT PK_CONTACTS PRIMARY KEY (Person_ID)
);

CREATE TABLE Campaigns
(
    Campaign_ID            INTEGER GENERATED ALWAYS AS IDENTITY, --aangepast naar integer
    Campaign_Creation_Date TIMESTAMP    NOT NULL,
    Campaign_Start_Date    TIMESTAMP,
    Campaign_End_Date      TIMESTAMP,
    Campaign_Description   VARCHAR(255) NOT NULL,
    Campaign_Purpose       VARCHAR(100) NOT NULL,
    Campaign_Requester_ID  INTEGER      NOT NULL,                --aangepast naar integer
    Campaign_Status        VARCHAR(30) DEFAULT 'Initial',
    CONSTRAINT Campaigns_ck_dates_start CHECK ( Campaign_End_Date > Campaign_Start_Date ),
    CONSTRAINT Campaigns_ck_dates_creation CHECK ( Campaign_Start_Date >= Campaign_Creation_Date ),
    CONSTRAINT PK_CAMPAIGNS PRIMARY KEY (Campaign_ID)

-- status is soort van functie. ==> kan afgeleid worden van datums, kan dus weg. (check constraint)

);

CREATE TABLE Reports
(
    Report_ID            INTEGER GENERATED ALWAYS AS IDENTITY,                     --aangepast naar integer
    Campaign_ID          INTEGER NOT NULL,
    Report_Creation_Date TIMESTAMP DEFAULT sysdate,
    Report_Sender_ID     INTEGER,                                                  --aangepast naar integer
    Report_Receiver_ID   INTEGER,                                                  --aangepast naar integer
    Report_Send_Date     TIMESTAMP,
    KindOFReport         varchar(10),                                              -- aanpassen naar kind of report
    CONSTRAINT PK_REPORTS PRIMARY KEY (Report_ID),
    CONSTRAINT Reports_ck_KINDOFREPORT CHECK (KINDOFREPORT IN ('Paper', 'Email')), -- Kind of report, email of paper
    CONSTRAINT reports_ck_DATE CHECK (Report_Send_Date > Report_Creation_Date)

);

-- gezamelijke tabellen

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

CREATE TABLE Measurements
(
    Measurement_ID         INTEGER GENERATED ALWAYS AS IDENTITY,
    Sample_ID              INTEGER       NOT NULL,
    Instrument_ID          INTEGER       NOT NULL, -- zou aanpassen naar NULL toegelaten (meeting zonder instrument?)
    Technician_ID          INTEGER       NOT NULL,
    Report_ID              INTEGER,
    Measurement_Start_Date TIMESTAMP,
    Measurement_End_Date   TIMESTAMP,
    Result                 NUMBER(10, 2),
    Unit                   VARCHAR(30),
    Measurement_Cost       NUMBER(10, 2) NOT NULL,
    CONSTRAINT PK_MEASUREMENTS PRIMARY KEY (Measurement_ID),
    CONSTRAINT Measurement_ck_dates CHECK ( Measurement_End_Date > Measurement_Start_Date ),
    CONSTRAINT Measurement_ck_result CHECK ( Result > 0)
);


--FK's S1

ALTER TABLE Lab_Technicians
    ADD CONSTRAINT LABORATORY_LAB_TECHNICIANS_FK
        FOREIGN KEY (Laboratory_ID)
            REFERENCES Laboratories (Laboratory_ID)
                DEFERRABLE
    ADD CONSTRAINT LABTECHNICIANS_LABTECHNICIA461
        FOREIGN KEY (Supervisor_ID)
            REFERENCES Lab_Technicians (Technician_ID)
                NOT DEFERRABLE;

--FK's S2

ALTER TABLE Reports
    ADD CONSTRAINT FK_REPORTS_CAMPAIGNS_CAMPAIGN_ID
        FOREIGN KEY (Campaign_ID)
            REFERENCES Campaigns (Campaign_ID)
                NOT DEFERRABLE
    ADD CONSTRAINT FK_REPORTS_CONTACTS_receiver_ID
        FOREIGN KEY (Report_Receiver_ID)
            REFERENCES Contacts (Person_ID)
                ON DELETE SET NULL NOT DEFERRABLE
    ADD CONSTRAINT FK_REPORTS_CONTACTS_SENDER_ID
        FOREIGN KEY (Report_Sender_ID)
            REFERENCES Contacts (Person_ID)
                ON DELETE SET NULL NOT DEFERRABLE;

ALTER TABLE Campaigns
    ADD CONSTRAINT FK_CAMPAIGNS_CONTACTS_REQUESTER_ID
        FOREIGN KEY (Campaign_Requester_ID)
            REFERENCES Contacts (Person_ID)
                ON DELETE SET NULL NOT DEFERRABLE;

--FK's SAMEN

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
    ADD CONSTRAINT FK_MEASUREMENT_LABORATORY_REPORT_ID
        FOREIGN KEY (REPORT_ID)
            REFERENCES REPORTS (REPORT_ID)
                NOT DEFERRABLE;




