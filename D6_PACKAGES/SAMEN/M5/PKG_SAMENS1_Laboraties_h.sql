CREATE OR REPLACE PACKAGE PKG_SAMENS1_M5_LABORATORIES
AS

    PROCEDURE empty_tables_S1;
--
    PROCEDURE bewijs_Milestone_M4_S1;

    PROCEDURE bewijs_milestone_M5_S1( p_amount_lab_technicians IN NUMBER DEFAULT 1,
                                  p_amount_samples IN NUMBER DEFAULT 1,
                                  p_amount_instruments IN NUMBER DEFAULT 1,
                                  p_amount_measurements IN NUMBER DEFAULT 1);
--

    PROCEDURE add_lab_technicians_samen;

    FUNCTION lookup_sample(p_sample_description IN Samples.Sample_Description%TYPE)
        RETURN Samples.Sample_ID%TYPE;

    FUNCTION lookup_instrument(p_instrument_description IN Instruments.INSTRUMENT_DESCRIPTION%TYPE)
        RETURN Instruments.Instrument_ID%TYPE;

    FUNCTION lookup_lab_technician(p_lab_technician_first_name IN Lab_Technicians.First_Name%TYPE,
                                   p_lab_technician_last_name IN Lab_Technicians.Last_Name%TYPE)
        RETURN Lab_Technicians.Technician_ID%TYPE;

END PKG_SAMENS1_M5_LABORATORIES;
