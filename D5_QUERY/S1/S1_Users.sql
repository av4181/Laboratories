CREATE USER ANDREAS IDENTIFIED BY sql1234AVL2024;

GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON Laboratories TO ANDREAS;
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON SAMPLES TO ANDREAS;
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON LAB_TECHNICIANS TO ANDREAS;

GRANT CREATE SESSION TO Andreas;

GRANT SELECT, UPDATE (MEASUREMENT_COST) ON MEASUREMENTS TO ANDREAS;


SELECT * FROM Laboratories;