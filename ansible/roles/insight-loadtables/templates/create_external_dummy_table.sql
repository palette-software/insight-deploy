-- Create dummy table
CREATE READABLE EXTERNAL TABLE {{ insight_schema_name }}.dummy_to_create_ext_error_table
(
    dummy int
)
LOCATION (
    'gpfdist://localhost:18001/*/dummy-*.csv.gz'
)
FORMAT 'TEXT' (delimiter ';' null '\\N' escape '\\' header)
ENCODING 'UTF8'
LOG ERRORS INTO "{{ insight_schema_name }}"."{{ ext_errors_table_name }}" SEGMENT REJECT LIMIT 1000 ROWS;

-- Drop the table
drop external table {{ insight_schema_name }}.dummy_to_create_ext_error_table;
