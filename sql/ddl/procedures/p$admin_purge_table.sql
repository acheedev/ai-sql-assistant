CREATE OR REPLACE PROCEDURE p$admin_purge_table (
    p_table_name VARCHAR2
) AS
    l_table_name VARCHAR2(30);
BEGIN
    SELECT table_name
      INTO l_table_name
      FROM user_tables
     WHERE table_name = upper(trim(p_table_name));

    dbms_output.put_line('Purging Table: ' || l_table_name);
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || dbms_assert.sql_object_name(l_table_name);
EXCEPTION
    WHEN no_data_found THEN
        NULL;
END;
/
