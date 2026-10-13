SELECT 'Operation' AS table_name, COUNT(*) AS row_count
FROM public."Operation"
UNION ALL
SELECT 'Staffing', COUNT(*)
FROM public."Staffing"
UNION ALL
SELECT 'Employee', COUNT(*)
FROM public."Employee"
UNION ALL
SELECT 'Area', COUNT(*)
FROM public."Area";
--COUNT all rows and check with data from Excel.--

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE operational_area IS NULL
    ) AS missing_area
FROM public."Operation";
--Check NULL value--

SELECT
    operation_date,
    hour_of_day,
    airport_code,
    operational_area,
    COUNT(*) AS record_count
FROM public."Operation"
GROUP BY
    operation_date,
    hour_of_day,
    airport_code,
    operational_area
HAVING COUNT(*) > 1;
--Check Duplicate--Recognize errors--

SELECT *
FROM public."Operation"
WHERE
    (operation_date = '2026-09-16'
     AND hour_of_day = 10
     AND airport_code = 'DFW'
     AND operational_area = 'Terminal Operations')
 OR (operation_date = '2026-09-22'
     AND hour_of_day = 9
     AND airport_code = 'DFW'
     AND operational_area = 'Terminal Operations')
ORDER BY operation_date, hour_of_day;
--Check 2nd time--

SELECT
    operation_date,
    hour_of_day,
    airport_code,
    operational_area,
    COUNT(*) AS record_count
FROM public."Staffing"
GROUP BY
    operation_date,
    hour_of_day,
    airport_code,
    operational_area
HAVING COUNT(*) > 1;
--Check Staffing table--


-- Create a cleaned copy of Staffing -- 
DROP TABLE IF EXISTS public."Staffing_Clean";

CREATE TABLE public."Staffing_Clean" AS
SELECT DISTINCT ON (
    to_jsonb(s) - 'staffing_record_id' - 'staffing_id' - 'id'
)
    s.*
FROM public."Staffing" AS s
ORDER BY
    to_jsonb(s) - 'staffing_record_id' - 'staffing_id' - 'id',
    s.ctid;


-- Create a cleaned copy of Operation --
DROP TABLE IF EXISTS public."Operation_Clean";

CREATE TABLE public."Operation_Clean" AS
SELECT DISTINCT ON (to_jsonb(o) - 'operation_id')
    o.*
FROM public."Operation" AS o
ORDER BY
    to_jsonb(o) - 'operation_id',
    o.operation_id;


