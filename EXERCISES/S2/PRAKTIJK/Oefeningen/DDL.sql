--vraag1

alter table TYPE_HUIZEN
    add constraint check_apers check ( APERS between 4 and 24) initially disable
;

select *
from TYPE_HUIZEN
where APERS < 4
   or APERS > 24
;

update TYPE_HUIZEN
set APERS = 4
where APERS < 4
;
commit;

UPDATE type_huizen
SET apers= 3
WHERE parkcode = 'WB'
  AND typenr = 'BC';

alter table TYPE_HUIZEN
    modify constraint check_apers enable novalidate;

select *
from USER_CONSTRAINTS
where TABLE_NAME = 'TYPE_HUIZEN'
;

insert into TYPE_HUIZEN (PARKCODE, TYPENR, ASLAAPK, APERS, ABADKAMER, KIBED2, COMMENTAAR, WIFI, OPP)
values ('WB', 'BC', 1, 1, 1, 1, 1, 'J', 63)
;

--vraag 2

alter table TYPE_HUIZEN
    drop constraint check_apers;

alter table TYPE_HUIZEN
    add constraint check_apers check ( apers between 4 and 24 ) deferrable enable novalidate
;

set constraint check_apers deferred
;

UPDATE type_huizen
SET apers= 3
WHERE parkcode = 'WB'
  AND typenr = 'BJ'
;

--vraag 3

alter table KLANTEN
    add email varchar2(30)
;

select *
from KLANTEN
;

create table hulp as
select KLNR,
       ACHTERNAAM,
       VOORNAAM,
       EMAIL,
       STRAAT,
       HUISNR,
       POSTCODE,
       GEMEENTE,
       STATUS
from KLANTEN
;


select *
from hulp
;
--data ook daar plus de not nulls

alter table hulp
    add constraint PK_KLANTEN primary key (KLNR);

drop table KLANTEN cascade constraints;
-- dropt de referenties in cascade niet de lijnen.

alter table hulp
    modify (VOORNAAM constraint VOORN_HFDL check ( voornaam = UPPER(voornaam) ),
            ACHTERNAAM CONSTRAINT ACHTERNM_HFDL CHECK ( achternaam = upper(achternaam) ),
            GEMEENTE CONSTRAINT GEMEENTE_HFDL CHECK ( gemeente = upper(gemeente) ),
            STRAAT CONSTRAINT KLANTSTRAAT_HFDL CHECK ( straat = upper(straat) ))
;

alter table hulp rename to KLANTEN
;

alter table RESERVATIES
    add constraint fk_res_klanten foreign key (KLNR) references KLANTEN (KLNR)
;


-- vraag 4
select TABLE_NAME, PCT_FREE, PCT_USED
from USER_TABLES
;

--a
---- alles heeft dezelfde PCT_free en used is niet ingevuld
--b
---- vanwege ASSM.

--vraag 5

create sequence SEQ_reservaties start with 1 maxvalue 1000 NOCYCLE NOCACHE;

/*alter table RESERVATIES
set unused  (RES_ID);

alter table RESERVATIES
drop unused columns;*/

alter table RESERVATIES
    add RES_ID number(4) default SEQ_reservaties.nextval
;

select *
from RESERVATIES
;

alter table RESERVATIES
    drop constraint PK_RESERV cascade;

alter table RESERVATIES
    add constraint pk_peserv primary key (RES_ID);

--opnieuw vreemde sleutel plaatsen naar gelinkte tabellen.


--vraag 6

alter table VAKANTIEHUIZEN
    modify constraint PK_VAKANTIEHUIS disable cascade;

select *
from USER_CONSTRAINTS
where CONSTRAINT_TYPE = 'R'
;

alter table VAKANTIEHUIZEN
    modify constraint PK_VAKANTIEHUIS enable
;

alter table RESERVATIES
    modify constraint FK_RES_VAKANTIEHUIS enable
;

alter table RESERVATIES
add (testje varchar2(50));



