CREATE OR REPLACE VIEW UV_TopMeasurementCost AS
SELECT m.MEASUREMENT_ID,
       m.MEASUREMENT_COST,
       lt.FIRST_NAME,
       lt.LAST_NAME,
       s.SAMPLE_DESCRIPTION,
       s.SAMPLE_STATUS
FROM MEASUREMENTS m
         JOIN LAB_TECHNICIANS lt on m.TECHNICIAN_ID = lt.TECHNICIAN_ID
         JOIN LABORATORY l on lt.LABORATORY_ID = l.LABORATORY_ID
         JOIN SAMPLE s on m.SAMPLE_ID = s.SAMPLE_ID
WHERE ROWNUM <= 3
ORDER BY m.MEASUREMENT_COST DESC;

select *
from UV_TOPMEASUREMENTCOST;

-- view zichtbaar voor iedereen dmv public synoniem met de juiste rechten.
CREATE PUBLIC SYNONYM UV_TopMeasurementCost FOR UV_TopMeasurementCost;
GRANT SELECT ON UV_TopMeasurementCost TO PUBLIC;
