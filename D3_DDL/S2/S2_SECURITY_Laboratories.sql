select 'Current user:', USER
from dual
;

--Check all accessible tables
select * from all_tables WHERE OWNER ='SAMEN';

--Check all accessible views
select * from all_views WHERE OWNER ='SAMEN';

--check system privileges linked to user
select * from USER_SYS_PRIVS;

--check object privileges linked to user
select * from USER_TAB_PRIVS;

--check ROLE priveleges linked to user
select * from USER_ROLE_PRIVS;

--check System privileges linked to the role
select * from ROLE_SYS_PRIVS
;

--check object privileges linked to role
select * from ROLE_TAB_PRIVS;

--check if view is available
select *
from UV_CampaignReports
;

--insert into view
INSERT INTO UV_CampaignReports
(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE, KINDOFREPORT)
values ((select CAMPAIGN_ID from CAMPAIGNS where CAMPAIGN_START_DATE = '30/08/20 11:16:15'), '30/08/20 11:25:00',
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'An' and LAST_NAME = 'Jacobs'),
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Andreas' and LAST_NAME = 'van Loon'), '30/08/20 11:30:00',
        'Email');