--  duckdb dw_marts.duckdb -c ".read build_marts.sql"


-- Step 1: DW - Create star schema tables
.read 01_dw_create_tables.sql


-- Step 2: DW - Load data from CSV files into the tables
.read 02_dw_load_schema.sql


-- Step 3: Mart - Create flat mart
.read 03_dw_create_flatmart.sql


-- Step 4: Mart - Create skills demand mart
.read 04_dw_create_skills_mart.sql


-- Step 5: Mart - Create priority roles mart
.read 05_dw_create_priority_mart.sql


-- Step 6: Mart - Update priority roles mart
.read 06_update_priority_mart.


-- Step 7: Mart - Create company prospecting mart
.read 07_dw_create_company_mart.sql


SELECT '=== Pipeline Build Complete ===' AS status;
SELECT 'All warehouse tables and marts created successfully' AS message;