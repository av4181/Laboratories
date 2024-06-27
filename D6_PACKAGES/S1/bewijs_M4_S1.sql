
SELECT 'S1 B - Laboratories' AS table_name, (SELECT COUNT(*) FROM Laboratories) AS table_count
FROM dual
UNION
SELECT 'S1 A - Samples', (SELECT COUNT(*) FROM Samples)
FROM dual
UNION
SELECT 'S1 C - Lab Technicians', (SELECT COUNT(*) FROM Lab_Technicians)
FROM dual
UNION
SELECT 'S1 C - Measurements', (SELECT COUNT(*) FROM Measurements)
FROM dual
UNION
SELECT 'S1 D - Instruments', (SELECT COUNT(*) FROM Instruments)
FROM dual;

ALTER PACKAGE PROJECT.PKG_S1_LABORATORIES COMPILE BODY;

BEGIN
    PKG_S1_LABORATORIES.empty_tables_S1();
END;
BEGIN
    PKG_S1_LABORATORIES.BEWIJS_MILESTONE_M4_S1();
END;
commit;

drop package body PKG_S1_LABORATORIES;
drop package PKG_S1_LABORATORIES;