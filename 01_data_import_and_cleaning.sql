UPDATE public."Employee"
SET operational_area = 'Baggage Operations'
WHERE LOWER(TRIM(operational_area)) = 'baggage operations';
--Issue identified: The Employee table contained inconsistent capitalization, including Baggage Operations and Baggage operations. This query standardizes matching values to Baggage Operations.--

SELECT
    operational_area,
    LENGTH(operational_area) AS char_count,
    LENGTH(TRIM(operational_area)) AS trimmed_length,
    COUNT(*) AS row_count
FROM public."Employee"
GROUP BY operational_area
ORDER BY operational_area;
--Observation: Ramp Operations appeared in two separate grouped results. This suggested a possible difference in whitespace or other characters, rather than necessarily indicating duplicate employee records.--

UPDATE public."Employee"
SET operational_area = CASE
    WHEN LOWER(TRIM(operational_area)) = 'baggage operations'
        THEN 'Baggage Operations'
    WHEN LOWER(TRIM(operational_area)) = 'ramp operations'
        THEN 'Ramp Operations'
    WHEN LOWER(TRIM(operational_area)) = 'terminal operations'
        THEN 'Terminal Operations'
    ELSE TRIM(operational_area)
END;
--Applied consistent capitalization and removed leading or trailing whitespace. This query standardizes recognized area names while trimming whitespace from other values.--

UPDATE public."Staffing"
SET operational_area = CASE
    WHEN LOWER(TRIM(operational_area)) = 'terminal operations'
        THEN 'Terminal Operations'
    WHEN LOWER(TRIM(operational_area)) = 'ramp operations'
        THEN 'Ramp Operations'
    WHEN LOWER(TRIM(operational_area)) = 'baggage operations'
        THEN 'Baggage Operations'
    ELSE operational_area
END
WHERE LOWER(TRIM(operational_area)) IN (
    'terminal operations',
    'ramp operations',
    'baggage operations'
);
--The Staffing table also contained operational area values that did not consistently match the reference table. This query standardizes the recognized operational area labels to match the values used in Area.--

SELECT
    operational_area,
    LENGTH(operational_area) AS char_count
FROM public."Area"
ORDER BY operational_area;
--Inspected the reference values and their string lengths before correcting the remaining foreign key issues.--

UPDATE public."Operation"
SET operational_area = CASE
    WHEN UPPER(TRIM(operational_area)) = 'BAGGAGE OPERATIONS'
        THEN 'Baggage Operations'
    WHEN UPPER(TRIM(operational_area)) = 'RAMP OPERATIONS'
        THEN 'Ramp Operations'
    WHEN UPPER(TRIM(operational_area)) = 'TERMINAL OPERATIONS'
        THEN 'Terminal Operations'
    ELSE operational_area
END
WHERE UPPER(TRIM(operational_area)) IN (
    'BAGGAGE OPERATIONS',
    'RAMP OPERATIONS',
    'TERMINAL OPERATIONS'
);
--A foreign key violation occurred because the Operation table contained values such as BAGGAGE OPERATIONS, which did not exactly match the canonical value in Area.--


