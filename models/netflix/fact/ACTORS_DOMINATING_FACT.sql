{{ config(
    pre_hook="ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = true",
    post_hook="GRANT SELECT ON TABLE {{ this }} TO ROLE TEST_DBT_ROLE"  
) }}

WITH ACTORS AS
(
    SELECT 
    ID
    ,NAME
    FROM PROD.DBT_TRANSFORM.CREDITS_DIM
    WHERE ROLE='ACTOR'
)

SELECT
REPLACE(REPLACE(UPPER(GENRES),'[',''),']','') AS GENRES
,ACTORS.NAME
,SUM(CASE WHEN GENRES IS NOT NULL THEN 1 ELSE 0 END) AS PERFORMANCES 
FROM PROD.DBT_TRANSFORM.SHOW_DETAILS_DIM AS SD
LEFT JOIN
ACTORS
ON SD.ID=ACTORS.ID
WHERE NAME IS NOT NULL
GROUP BY 1,2


