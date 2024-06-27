--vraag 1

select * from DBA_INDEXES
;

--allemaal automatisch aangemaakt
--zelfde naamgeving als constraints


--vraag 2

select * from USER_INDEXES
where TABLE_NAME = 'TYPE_HUIZEN'
;

select * from ALL_CONS_COLUMNS
where TABLE_NAME = 'TYPE_HUIZEN'
;

-- nee typenr heeft een grotere verscheidenheid dus zou vooraan moeten staan

--vraag 3

select * from DBA_INDEXES
where TABLE_NAME = 'TYPE_HUIS_PRIJZEN'
;

alter table TYPE_HUIS_PRIJZEN
disable primary key cascade
;

-- nu geen indexen meer

alter table TYPE_HUIS_PRIJZEN
    modify constraint PK_TYPEHPRIJZEN enable
;

drop index PK_TYPEHPRIJZEN
; -- gaat niet zolang PK actief is.

--vraag 4

CREATE TABLE klanten1
AS SELECT *
   FROM klanten;
ALTER TABLE klanten1
    MODIFY klnr CONSTRAINT pk_klanten1 PRIMARY KEY;

select status, DBA_INDEXES.* from DBA_INDEXES
where TABLE_NAME = 'KLANTEN1'
;
--valid

alter index pk_klanten1 unusable
;

--unusable

alter index pk_klanten1 rebuild
;

--vraag 5

select distinct to_char(BOEKINGSDATUM, 'yyyy') Years from RESERVATIES
;

create table RESERVATIES2
(
    RESNR         NUMBER(4) not null,
    BUNR          NUMBER(2) not null
        constraint FK_RES_BUR2
            references REISBURS
                on delete cascade,
    KLNR          VARCHAR2(5)
        constraint FK_RES_KLANT2
            references KLANTEN,
    PARKCODE      VARCHAR2(2)
        constraint PARKCODE3_HFDL2
            check (parkcode = upper(parkcode)),
    TYPENR        VARCHAR2(5)
        constraint TYP_HFDL_12
            check (typenr = upper(typenr)),
    HNR           NUMBER(3),
    BOEKINGSDATUM DATE,
    BEGINDAT      DATE,
    EINDDAT       DATE,
    KODE          NUMBER(1)
        constraint CC_RESV_KODE2
            check (kode IN (1, 2)),
    STATUS        VARCHAR2(8)
        constraint CC_RES_STATUS2
            check (status in ('OPEN', 'BETAALD', 'GESLOTEN')),
    PROMOCODE     VARCHAR2(9)
        constraint FK_RES_PROMO2
            references PROMOTIES,
    constraint PK_RESERV2
        primary key (RESNR, BUNR),
    constraint FK_RES_VAKANTIEHUIS2
        foreign key (PARKCODE, TYPENR, HNR) references VAKANTIEHUIZEN
            on delete cascade,
    constraint INTEGR_DATUMS2
        check (einddat >= begindat)
)
    PARTITION BY RANGE (BOEKINGSDATUM)
    INTERVAL(NUMTOYMINTERVAL(1, 'YEAR'))
( PARTITION p0 VALUES LESS THAN (TO_DATE('1-1-2018', 'DD-MM-YYYY'))
    , PARTITION p1 VALUES LESS THAN (TO_DATE('1-1-2019', 'DD-MM-YYYY'))
    , PARTITION p2 VALUES LESS THAN (TO_DATE('1-1-2020', 'DD-MM-YYYY')) );

INSERT INTO RESERVATIES2
    (SELECT * from RESERVATIES);

SELECT *
FROM DBA_TAB_PARTITIONS
WHERE lower(TABLE_OWNER)='praktijk';

drop table RESERVATIES2
;


