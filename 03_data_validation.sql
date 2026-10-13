
-- Compare row counts before and after cleaning --
SELECT 'Staffing - Raw' AS table_name, COUNT(*) AS row_count
FROM public."Staffing"

UNION ALL

SELECT 'Staffing - Clean', COUNT(*)
FROM public."Staffing_Clean"

UNION ALL

SELECT 'Operation - Raw', COUNT(*)
FROM public."Operation"

UNION ALL

SELECT 'Operation - Clean', COUNT(*)
FROM public."Operation_Clean";


--Check/Validate Operation_Clean,  Staffing_Clean--
SELECT DISTINCT operational_area
FROM public."Operation_Clean"
WHERE operational_area NOT IN (
    'Baggage Operations',
    'Ramp Operations',
    'Terminal Operations'
)
OR operational_area IS NULL;


