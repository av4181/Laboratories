create PACKAGE PKG_SAMENS2_M4_LABORATORIES
AS

    PROCEDURE empty_tables_S2; -- ==> boolean vanwege gezamelijke tabel met FK's.

    PROCEDURE bewijs_Milestone_M4_S2;

    PROCEDURE add_laboratory_samen;

    FUNCTION lookup_report(p_campaign_start IN CAMPAIGNS.CAMPAIGN_START_DATE%TYPE,
                           p_requester_firstname IN CONTACTS.FIRST_NAME%TYPE,
                           p_requester_lastname IN CONTACTS.LAST_NAME%TYPE,
                           p_report_creation_date in REPORTS.REPORT_CREATION_DATE%TYPE,
                           p_sender_firstname IN CONTACTS.FIRST_NAME%TYPE,
                           p_sender_lastname IN CONTACTS.LAST_NAME%TYPE)
        RETURN REPORTS.REPORT_ID%TYPE;


END PKG_SAMENS2_M4_LABORATORIES;
/


