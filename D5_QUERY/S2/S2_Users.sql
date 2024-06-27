create role ReportsAdmin; --table Y = Reports

grant SELECT, INSERT, DELETE, UPDATE, ALTER ON REPORTS to ReportsAdmin;
GRANT CREATE SESSION TO ReportsAdmin;

create role CampaignManager;

grant SELECT, INSERT, DELETE on CAMPAIGNS to CampaignManager;
grant SELECT on CONTACTS to campaignManager;
GRANT CREATE SESSION TO CampaignManager;
GRANT INSERT, SELECT on UV_CampaignReports TO CampaignManager;
GRANT SELECT on CAMPAIGNS to CAMPAIGNMANAGER;
GRANT SELECT on CONTACTS to CAMPAIGNMANAGER;

create USER STEF IDENTIFIED BY User1234NeemHetWwAanAub
;

grant CampaignManager, ReportsAdmin to STEF;

select * from campaigns

