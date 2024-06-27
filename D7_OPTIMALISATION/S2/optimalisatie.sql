begin
    PKG_SAMENS2_M7_LABORATORIES.BEWIJS_MILESTONE_M7_S2(30, 30, 30, 700, false);
end;

--Gather STATS
BEGIN
    DBMS_STATS.GATHER_TABLE_STATS('SAMEN', 'MEASUREMENTS');
    DBMS_STATS.GATHER_TABLE_STATS('SAMEN', 'REPORTS');
end;

--CHECK grootte (42-43MB, 630 000 lijnen)
select segment_name,
       segment_type,
       sum(bytes / 1024 / 1024)               MB,
       (select COUNT(*) FROM MEASUREMENTS) as table_count
from dba_segments
where segment_name = 'MEASUREMENTS'
group by segment_name, segment_type;


--Query
-- Ik wil het aantal analyses zien dat gedaan zijn per rapport per campaigne en de bijhorende informatie
select count(MEASUREMENT_ID) as "amount of measurements",
       r.REPORT_ID,
       REPORT_SEND_DATE      as Report_send_time,
       r.CAMPAIGN_ID
from measurements m
         inner join REPORTS r
                    on r.REPORT_ID = m.REPORT_ID
group by r.CAMPAIGN_ID, r.REPORT_ID, REPORT_SEND_DATE
order by 4, 2
;

--grant rights on USER
GRANT CREATE ANY TABLE to SAMEN;

--insert before materialized view
insert into MEASUREMENTS(sample_id, instrument_id, technician_id, report_id, measurement_start_date, measurement_end_date, result, unit, measurement_cost)
values(1,2,5,168,(SYSTIMESTAMP - NUMTODSINTERVAL(50, 'HOUR')), SYSTIMESTAMP, 120.21,'g',250);

--create view
create materialized view vw_amount_of_samples_per_report
            BUILD IMMEDIATE
    REFRESH FAST
as
select count(MEASUREMENT_ID) as "amount of measurements",
       r.REPORT_ID,
       REPORT_SEND_DATE      as Report_send_time,
       r.CAMPAIGN_ID
from measurements m
         inner join REPORTS r
                    on r.REPORT_ID = m.REPORT_ID
group by r.CAMPAIGN_ID, r.REPORT_ID, REPORT_SEND_DATE
order by 4, 2;

--select results by selection the view
select *
from vw_amount_of_samples_per_report;

--drop in case of restart.
drop materialized view vw_amount_of_samples_per_report;

