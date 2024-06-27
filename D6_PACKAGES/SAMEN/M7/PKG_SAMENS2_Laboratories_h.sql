create or replace PACKAGE PKG_SAMENS2_M7_LABORATORIES
AS
    PROCEDURE empty_tables_S2;

    PROCEDURE bewijs_Milestone_M4_S2;

    PROCEDURE add_laboratory_samen;

    FUNCTION lookup_report(p_campaign_start IN CAMPAIGNS.CAMPAIGN_START_DATE%TYPE,
                           p_requester_firstname IN CONTACTS.FIRST_NAME%TYPE,
                           p_requester_lastname IN CONTACTS.LAST_NAME%TYPE,
                           p_report_creation_date in REPORTS.REPORT_CREATION_DATE%TYPE,
                           p_sender_firstname IN CONTACTS.FIRST_NAME%TYPE,
                           p_sender_lastname IN CONTACTS.LAST_NAME%TYPE)
        RETURN REPORTS.REPORT_ID%TYPE;

    PROCEDURE add_multiple_laboratories(p_row_amount IN NUMERIC);

    PROCEDURE bewijs_milestone_M5_S2(p_aantal_w_laboraties IN NUMERIC, p_aantal_x_campaigns IN NUMERIC,
                                     p_aantal_y_reports_x IN NUMERIC, p_aantal_z_measurements_y IN NUMERIC);

    PROCEDURE bewijs_milestone_M7_S2(p_aantal_w_laboraties IN NUMERIC, p_aantal_x_campaigns IN NUMERIC,
                                     p_aantal_y_reports_x IN NUMERIC, p_aantal_z_measurements_y IN NUMERIC,
                                     p_execute_M5 IN BOOLEAN);

END PKG_SAMENS2_M7_LABORATORIES;