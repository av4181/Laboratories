-- drop is needed
-- PURGE OPTIE LATEN STAAN! zorgt voor het verwijderen van de identity columns.
DROP TABLE MEASUREMENTS PURGE;
DROP TABLE REPORTS PURGE;
DROP TABLE CAMPAIGNS PURGE;
DROP TABLE CONTACTS PURGE;
DROP TABLE LABORATORY PURGE;

--create CONTACTS with check-constraints and PK
CREATE TABLE Contacts
(
    Person_ID   INTEGER GENERATED ALWAYS AS IDENTITY,
    First_Name  VARCHAR(30) NOT NULL,
    Last_Name   VARCHAR(50) NOT NULL,
    Middle_Name VARCHAR(50),
    Email       VARCHAR(255),
    CONSTRAINT PK_CONTACTS PRIMARY KEY (Person_ID)
);

--create CAMPAIGN with check-constraints and PK
CREATE TABLE Campaigns
(
    Campaign_ID            NUMERIC GENERATED ALWAYS AS IDENTITY,
    Campaign_Creation_Date TIMESTAMP    NOT NULL,
    Campaign_Start_Date    TIMESTAMP,
    Campaign_End_Date      TIMESTAMP,
    Campaign_Description   VARCHAR(255) NOT NULL,
    Campaign_Purpose       VARCHAR(100) NOT NULL,
    Campaign_Requester_ID  INTEGER      NOT NULL,
    Campaign_Status        VARCHAR(15) DEFAULT 'Initial',
    CONSTRAINT Campaigns_ck_dates_start CHECK ( Campaign_End_Date > Campaign_Start_Date ),
    CONSTRAINT Campaigns_ck_dates_creation CHECK ( Campaign_Start_Date >= Campaign_Creation_Date ),
    CONSTRAINT PK_CAMPAIGNS PRIMARY KEY (Campaign_ID)
);

--create REPORTS with check-constraints and PK
CREATE TABLE Reports
(
    Report_ID            INTEGER GENERATED ALWAYS AS IDENTITY,
    Campaign_ID          INTEGER NOT NULL,
    Report_Creation_Date TIMESTAMP DEFAULT sysdate,
    Report_Sender_ID     INTEGER,
    Report_Receiver_ID   INTEGER,
    Report_Send_Date     TIMESTAMP,
    KindOfReport         varchar(10),
    CONSTRAINT PK_REPORTS PRIMARY KEY (Report_ID),
    CONSTRAINT Reports_ck_KINDOFREPORT CHECK (KINDOFREPORT IN ('Paper', 'Email')), -- Kind of report, email of paper
    CONSTRAINT reports_ck_DATE CHECK (Report_Send_Date > Report_Creation_Date)
);

--create MEASUREMENTS with check-constraints and PK
CREATE TABLE Measurements
(
    Measurement_ID         INTEGER GENERATED ALWAYS AS IDENTITY,
    Report_ID              INTEGER,
    Laboratory_ID          INTEGER       NOT NULL,
    Measurement_Start_Date TIMESTAMP,
    Measurement_End_Date   TIMESTAMP,
    Result                 NUMERIC(10, 2), --aangepast naar numeric
    Unit                   VARCHAR2(10),
    Measurement_Cost       NUMBER(10, 2) NOT NULL,
    CONSTRAINT PK_MEASUREMENTS PRIMARY KEY (Measurement_ID),
    CONSTRAINT Measurement_ck_dates CHECK ( Measurement_End_Date > Measurement_Start_Date ),
    CONSTRAINT Measurement_ck_result CHECK ( Result > 0)
);

--create LABORATORY with check-constraints and PK
CREATE TABLE Laboratory
(
    Laboratory_ID            NUMERIC GENERATED ALWAYS AS IDENTITY,
    Laboratory_Name          VARCHAR2(50)  NOT NULL, --angepast naar 50
    Laboratory_Description   VARCHAR2(255),
    Laboratory_Street_Number numeric(3)    NOT NULL,
    Laboratory_Street        VARCHAR2(255) NOT NULL,
    Laboratory_location      VARCHAR2(100) NOT NULL,
    Company                  VARCHAR2(50)  NOT NULL,
    CONSTRAINT PK_LABORATORY PRIMARY KEY (Laboratory_ID)
);

--link tables with FK's
ALTER TABLE Measurements
    ADD CONSTRAINT FK_MEASUREMENT_LABORATORY_LABORATORY_ID
        FOREIGN KEY (Laboratory_ID)
            REFERENCES Laboratory (Laboratory_ID)
                NOT DEFERRABLE
    ADD CONSTRAINT FK_MEASUREMENT_LABORATORY_REPORT_ID
        FOREIGN KEY (REPORT_ID)
            REFERENCES REPORTS (REPORT_ID)
                NOT DEFERRABLE;

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


