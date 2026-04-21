CREATE OR REPLACE PROCEDURE p$admin_drop_all_views AS
    CURSOR base_views IS
    SELECT view_name
      FROM user_views
     WHERE view_name LIKE 'V_%';

BEGIN
    FOR i IN base_views LOOP
        p$admin_drop_view(i.view_name);
    END LOOP;
END;
/
