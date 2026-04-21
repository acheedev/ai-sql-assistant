CREATE OR REPLACE PROCEDURE p$admin_drop_all_basetables AS
    CURSOR base_tables IS
    SELECT table_name
      FROM user_tables
     WHERE table_name NOT LIKE 'T_SEMANTIC%'
       AND table_name LIKE 'T_%';

BEGIN
    FOR i IN base_tables LOOP
        p$admin_drop_table(i.table_name);
    END LOOP;
END;
/
