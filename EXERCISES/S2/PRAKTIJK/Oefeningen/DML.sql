--Vraag 1

--controle tabel
select *
from KLANTEN
order by 1;

savepoint KLANT;

insert into KLANTEN (KLNR, ACHTERNAAM, VOORNAAM, STRAAT, HUISNR, POSTCODE, GEMEENTE)
VALUES (1, 'HENDERICKX', 'STEF', 'ROOSENDAALSEBAAN', 62, 2920, 'KALMTHOUT');

savepoint RESERVATIE1;

insert into RESERVATIES (RESNR, BUNR, KLNR, PARKCODE, BEGINDAT, EINDDAT, HNR, TYPENR)
values ((select max(RESNR) + 1 from RESERVATIES), 1, 1,
        (select PARKCODE from VAKANTIEHUIZEN where VAKANTIEHUIZEN.HNR = 225), '28/10/2022', '1/11/2022', 225,
        (select VAKANTIEHUIZEN.TYPENR from VAKANTIEHUIZEN where VAKANTIEHUIZEN.HNR = 225));

savepoint RESERVATIE2;

insert into RESERVATIES (RESNR, BUNR, KLNR, PARKCODE, BEGINDAT, EINDDAT)
values ((select max(RESNR) + 1 from RESERVATIES), 1, 1,
        (select PARKCODE from VAKANTIEHUIZEN where VAKANTIEHUIZEN.HNR = 515), '23/12/2022', '27/12/2022');

savepoint BETALING;

insert into BETALINGEN (BETALINGSNR, RESNR, BUNR, DATUMBETALING, BEDRAG, BETALINGSWIJZE)
values ((select max(BETALINGSNR) + 1 from BETALINGEN), 51, 1, CURRENT_TIMESTAMP, 200, 'B');

--rollback to savepoint BETALING;

commit;

--Vraag 2

select r.*
from RESERVATIES r
         inner join KLANTEN k
                    on k.KLNR = r.KLNR
where lower(K.VOORNAAM) = 'pieter'
  and lower(k.ACHTERNAAM) = 'stoot'
;

select PARKCODE, TYPENR, ABADKAMER
from TYPE_HUIZEN
where ABADKAMER = (select max(ABADKAMER) from TYPE_HUIZEN)
order by 2 desc
;

alter table KLANTEN
    disable primary key;

delete
from KLANTEN
where lower(VOORNAAM) = 'pieter'
  and lower(ACHTERNAAM) = 'stoot'
;

-- gaat niet cuz constraint... dus kan niet verwijderen zolang er afhankelijk records zijn

delete
from VAKANTIEHUIZEN
where HNR = 225;

select *
from RESERVATIES
where HNR = 225;

rollback;

--no issues, als alles mooi ingevuld is, worden de afhankelijke lijnen verwijderd. (on delete cascade in tabel creatie)


--vraag 3

-- select * from TYPE_HUIS_PRIJZEN
-- where PARKCODE in (select CODE from PARKEN
--                    where LANDCODE = (select LANDCODE from LANDEN where lower(LANDNAAM) = 'nederland'));
--select * from SEIZOENEN;
--zomervakantie 2019 = seizoen 1
-- select * from PARKEN
--     where LANDCODE = (select LANDCODE from LANDEN where lower(LANDNAAM) = 'nederland')
--         ;

update TYPE_HUIS_PRIJZEN
set PRIJS_WEEKEND = PRIJS_WEEKEND * 1.10,
    PRIJS_MIDWEEK = PRIJS_MIDWEEK * 1.10
where SEIZOENCODE = 1
  and parkcode in (select CODE
                   from PARKEN
                   where LANDCODE = (select LANDCODE from LANDEN where lower(LANDNAAM) = 'nederland'))
;
-- kan pas lezen terug na een commit. Because database lock vanwege update (transactie)
commit;




