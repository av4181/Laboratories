create PACKAGE PKG_SAMENS1_M4_LABORATORIES
AS

    PROCEDURE empty_tables_S1;

    PROCEDURE bewijs_Milestone_M4_S1;

    FUNCTION lookup_sample(p_sample_description IN Samples.Sample_Description%TYPE)
        RETURN Samples.Sample_ID%TYPE;

    FUNCTION lookup_instrument(p_instrument_description IN Instruments.INSTRUMENT_DESCRIPTION%TYPE)
        RETURN Instruments.Instrument_ID%TYPE;

    FUNCTION lookup_lab_technician(p_lab_technician_first_name IN Lab_Technicians.First_Name%TYPE,
                                   p_lab_technician_last_name IN Lab_Technicians.Last_Name%TYPE)
        RETURN Lab_Technicians.Technician_ID%TYPE;

END PKG_SAMENS1_M4_LABORATORIES;
/

