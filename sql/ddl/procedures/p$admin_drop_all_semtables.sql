CREATE OR REPLACE PROCEDURE p$admin_drop_all_semtables AS
    CURSOR sem_tables IS
    SELECT table_name
      FROM user_tables
     WHERE table_name LIKE 'T_SEMANTIC%';

BEGIN
    FOR i IN sem_tables LOOP
        p$admin_drop_table(i.table_name);
    END LOOP;
END;
/
