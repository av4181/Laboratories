SELECT VALUE
FROM v$parameter
WHERE NAME = 'optimizer_mode';

CREATE INDEX ind_postcode_klanten ON klanten(postcode);

SELECT *
FROM klanten
WHERE postcode = '2640';

SELECT /*+ FULL(klanten)*/ *
FROM klanten
WHERE postcode = '2640';

--vraag 1

SELECT *
FROM klanten
WHERE klnr = 77777;

--klnr is een varchar de binding waarde is een char ==> eerst conversie. index is geen function base index dus geen index

--vraag 2

create index IND_VOORNAAM_KLANT on KLANTEN(VOORNAAM);

--a
SELECT /*+ FIRST_ROWS */  klnr,voornaam,achternaam
FROM klanten
WHERE voornaam IS NULL;

--FTS want IS NULL op index attr

--b
SELECT /*+ INDEX(KLANTEN ind_voornaam_achternaam)*/
klnr,voornaam,achternaam
FROM klanten
WHERE voornaam IS NULL;

--FTS want hint index niet gekend

--C
SELECT *
FROM klanten
WHERE voornaam='WILLY';

--index ranged scan

--d.
SELECT /*+ INDEX(KLANTEN ind_voornaam_klant) */ *
FROM klanten
WHERE voornaam='WILLY';

--index ranged scan

--e
SELECT /*+ FIRST_ROWS */ klnr, voornaam,achternaam
FROM klanten
WHERE UPPER(voornaam) = 'WILLY';

--FTS want function

--f.
SELECT /*+ INDEX(KLANTEN ind_voornaam_klant) */  *
FROM klanten
WHERE voornaam LIKE '%TH%';

--index scan want hint. FULL INDEX SCAN? ==> %..% = FULL INDEX ?

--g.
SELECT *
FROM klanten
WHERE voornaam LIKE 'NAT%';

-- INDEX RANGEd scan want hij weet dat hij naar waarde grote/kleiner dan NAT moet zoeken.
--bij %NAT% is het FTS ==> Toch niet het geval? Full index scan?

--vraag 3

--A
SELECT *
FROM vakantiehuizen
WHERE hnr = 10;

--skip scan want samengestelde index en HNR is laatste attr.

--b
SELECT *
FROM vakantiehuizen
WHERE hnr = 10
  AND typenr= '62';

--Dito vorige maar laatste 2

--C
SELECT parkcode,typenr,hnr
FROM vakantiehuizen
WHERE parkcode='EP';

--ranged scan want eerste attr van samengestelde index.

--vraag 4

create index IND_ACHTERNAAM_KLANT on KLANTEN(ACHTERNAAM);

SELECT /*+ INDEX(klanten ind_achternaam_klant) */  *
                        FROM klanten
                        WHERE achternaam='STOOT';
--ranged scan

--b
SELECT /*+ INDEX(ind_achternaam_klant) */ *
FROM klanten
WHERE UPPER(achternaam)='STOOT';

--function FTS want index die meegegeven wordt is geen function base index

--c
drop index IND_ACHTERNAAM_KLANT;

create index IND_ACHTERNAAM_KLANTEN on KLANTEN(upper(ACHTERNAAM));

SELECT *
FROM klanten
WHERE UPPER(achternaam)='STOOT';

--vraag 5
--a
create index IND_KLANT_RES on RESERVATIES(KLNR);

--b
select /*+ INDEX(RESERVATIES IND_KLANT_RES)*/
    KLNR, count(*) from RESERVATIES
group by KLNR
order by KLNR
;
--blijft die niet gebruiken wegens sorteren.

Drop index IND_ACHTERNAAM_KLANTEN;
drop index IND_VOORNAAM_KLANT;
drop index IND_KLANT_RES;


--vraag 6
--a
SELECT /*+ FIRST_ROWS */ K.klnr, k.voornaam,k.achternaam
FROM  klanten k
          JOIN reservaties r ON  r.klnr = k.klnr;

--Nested loop driving table is RESERVATIES

--b
SELECT /*+ FIRST_ROWS */ k.achternaam, k.voornaam,p.sport,
p.pnaam,r.typenr,r.hnr
FROM reservaties r
JOIN klanten k ON k.klnr=r.klnr
JOIN parken p ON p.code=r.parkcode
WHERE p.landcode = 1;

--nested loop driving table is PARKEN EN RESERVATIES.

--vraag 7
--a
SELECT pa.parkcode,pa.attractietype,pat.beschrijving
FROM parkattracties pa
JOIN parkattractietypes pat ON
    pa.attractietype=pat.attractietype;

--hash join. FULL TABLE SCAN + geen sortering want de hash join is al gesorteerd op de key

SELECT t.parkcode,t.typenr,apers,hnr,centrum
FROm type_huizen t
         JOIN vakantiehuizen v  ON v.parkcode=t.parkcode
    AND v.typenr=t.typenr;

--hash join met 2 full table scans. geen sortering want de hashjoin is als gesorteerd op de key

--vraag 8
SELECT *
FROM reisburs
WHERE bunr NOT IN
      (SELECT bunr
       FROM reservaties);
--full table scan van RESBURS en RESERVATIES met hashjoin ==> 2 aparte queries input gebruikt

SELECT *
FROM reisburs r
WHERE NOT EXISTS
          (SELECT 'x'
           FROM reservaties
           WHERE r.bunr = bunr);

--dito vorige maar wel een hash join

SELECT bunr
FROM reisburs
MINUS
SELECT bunr
FROM reservaties;

--vraag 9
SELECT  achternaam, 'klant'
FROM klanten
UNION
SELECT  bunaam ,'reisbureau'
FROM reisburs;

-- 2 table scans dan union dan sorteren dus dubbels weg?

SELECT  achternaam, 'klant'
FROM klanten
UNION ALL
SELECT  bunaam ,'reisbureau'
FROM reisburs;

--full table scan op beide daarna union en klaar.

--vraag 10
create index IND_KLNR_RES on RESERVATIES(KLNR);

SELECT /*+ USE_NL(r,k) */ *
FROM reservaties r
         JOIN  klanten k ON  r.klnr=k.klnr;

SELECT /*+ USE_MERGE(r,k) */ *
FROM reservaties r
         JOIN  klanten k ON  r.klnr=k.klnr;

create index ind_voornaam_achternaam on KLANTEN(VOORNAAM, ACHTERNAAM);

select /*+ INDEX(KLANTEN ind_voornaam_achternaam) */
KLNR, voornaam, ACHTERNAAM
from KLANTEN
where voornaam IS NULL
;

alter table KLANTEN
modify voornaam constraint nn_voornaam not null validate;

alter table RESERVATIES
modify constraint FK_RES_BUR CASCADE;

select postcode
from KLANTEN
where postcode like 's%'