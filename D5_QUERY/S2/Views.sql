create or replace view UV_CampaignReports
as
select REPORTS.CAMPAIGN_ID,
       CAMPAIGN_STATUS,
       CAMPAIGN_REQUESTER_ID,
       REPORT_ID,
       REPORT_CREATION_DATE,
       REPORT_SEND_DATE,
       REPORT_SENDER_ID,
       REPORT_RECEIVER_ID,
       KINDOFREPORT
from CAMPAIGNS
         inner join REPORTS on CAMPAIGNS.CAMPAIGN_ID = REPORTS.CAMPAIGN_ID
;

select *
from UV_CampaignReports
;

drop view UV_CampaignReports;


GRANT INSERT, SELECT on UV_CampaignReports TO STEF;


INSERT INTO UV_CampaignReports
(CAMPAIGN_ID, REPORT_CREATION_DATE, REPORT_SENDER_ID, REPORT_RECEIVER_ID, REPORT_SEND_DATE, KINDOFREPORT)
values ((select CAMPAIGN_ID from CAMPAIGNS where CAMPAIGN_START_DATE = '30/08/20 11:16:15'), '30/08/20 11:25:00',
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'An' and LAST_NAME = 'Jacobs'),
        (select PERSON_ID from CONTACTS where FIRST_NAME = 'Andreas' and LAST_NAME = 'van Loon'), '30/08/20 11:30:00',
        'Email');
