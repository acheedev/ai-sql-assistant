create or replace PROCEDURE p$admin_purge_all_basetables AS
    CURSOR base_tables IS
    SELECT table_name
      FROM user_tables
     WHERE table_name NOT LIKE 'T_SEMANTIC%'
       AND table_name LIKE 'T_%';

    CURSOR owner_fk_constraints (p_table_name VARCHAR2, p_enable BOOLEAN) IS
    SELECT 'ALTER TABLE ' || owner || '.' || table_name ||
           CASE p_enable WHEN TRUE THEN ' ENABLE ' ELSE ' DISABLE ' END ||
           ' CONSTRAINT ' || constraint_name AS ddl
    FROM   all_constraints
    WHERE  table_name = TRIM(UPPER(p_table_name))
    AND    constraint_type = 'R';

    CURSOR related_fk_constraints (p_table_name VARCHAR2, p_enable BOOLEAN) IS
    SELECT 'ALTER TABLE ' || owner || '.' || table_name ||
           CASE p_enable WHEN TRUE THEN ' ENABLE ' ELSE ' DISABLE ' END ||
           ' CONSTRAINT ' || constraint_name AS ddl
    FROM   all_constraints
    WHERE  r_owner = USER
    AND    r_constraint_name = (
             SELECT constraint_name
             FROM   user_constraints
             WHERE  table_name = TRIM(UPPER(p_table_name))
             AND    constraint_type = 'P'
           );

BEGIN
    FOR i IN base_tables LOOP
        DBMS_OUTPUT.PUT_LINE('DISABLING CONSTRAINTS ON: '||i.table_name);
        FOR x IN owner_fk_constraints(i.table_name, FALSE) LOOP
            EXECUTE IMMEDIATE x.ddl;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('DISABLING CONSTRAINTS RELATING TO: '||i.table_name);
        FOR x IN related_fk_constraints(i.table_name, FALSE) LOOP
            EXECUTE IMMEDIATE x.ddl;
        END LOOP;
        p$admin_purge_table(i.table_name);
    END LOOP;
    FOR i IN base_tables LOOP
        DBMS_OUTPUT.PUT_LINE('ENABLING CONSTRAINTS RELATING TO: '||i.table_name);
        FOR x IN owner_fk_constraints(i.table_name, TRUE) LOOP
            EXECUTE IMMEDIATE x.ddl;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('ENABLING CONSTRAINTS RELATING TO: '||i.table_name);
        FOR x IN related_fk_constraints(i.table_name, TRUE) LOOP
            EXECUTE IMMEDIATE x.ddl;
        END LOOP;
    END LOOP;

END;
/
