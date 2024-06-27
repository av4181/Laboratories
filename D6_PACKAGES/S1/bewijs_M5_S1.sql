SELECT 'S1/S2 A/W - Samples', (SELECT COUNT(*) FROM Samples)
FROM dual
UNION
SELECT 'S1 B - Lab Technicians', (SELECT COUNT(*) FROM Lab_Technicians)
FROM dual
UNION
SELECT 'S1/S2 D/Z - Measurements', (SELECT COUNT(*) FROM Measurements)
FROM dual
UNION
SELECT 'S1 C - Instruments', (SELECT COUNT(*) FROM Instruments)
FROM dual
UNION
SELECT 'S1/S2 /W- Laboratories' AS table_name, (SELECT COUNT(*) FROM Laboratories) AS table_count
FROM dual;


ALTER PACKAGE PKG_S1_LABORATORIES COMPILE BODY;

BEGIN
    PKG_S1_LABORATORIES.EMPTY_TABLES_S1();
end;

BEGIN
    PKG_S1_LABORATORIES.bewijs_milestone_M5_S1(3000,3000,3000,400000);
END;
