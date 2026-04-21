CREATE OR REPLACE PROCEDURE p$admin_drop_view (
    p_view_name VARCHAR2
) AS
    l_view_name VARCHAR2(30);
BEGIN
    SELECT view_name
      INTO l_view_name
      FROM user_views
     WHERE view_name = upper(trim(p_view_name));

    dbms_output.put_line('Deleting View: ' || l_view_name);
    EXECUTE IMMEDIATE 'DROP VIEW ' || dbms_assert.sql_object_name(l_view_name);
EXCEPTION
    WHEN no_data_found THEN
        NULL;
END;
/
