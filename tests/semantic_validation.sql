SELECT view_name,
       (
           SELECT COUNT(*)
             FROM t_semantic_object
            WHERE object_name = v.view_name
       ) sem_objects,
       (
           SELECT COUNT(*)
             FROM t_semantic_column
            WHERE object_name = v.view_name
       ) sem_column_cols,
       (
           SELECT COUNT(*)
             FROM user_tab_cols
            WHERE table_name = v.view_name
       ) dd_column_cols,
       (
           SELECT COUNT(*)
             FROM t_semantic_column
            WHERE object_name = v.view_name
              AND is_identifier != 'Y'
              AND column_name LIKE '%\_ID' ESCAPE '\'
       ) ids_not_marked_identifier,
       (
           SELECT COUNT(*)
             FROM t_semantic_column
            WHERE object_name = v.view_name
              AND is_identifier = 'Y'
              AND column_name NOT LIKE '%\_ID' ESCAPE '\'
       ) non_ids_marked_identifier,
       (
           SELECT
               LISTAGG(column_name,',') WITHIN GROUP (ORDER BY column_name)
             FROM t_semantic_column
            WHERE object_name = v.view_name
              AND is_identifier = 'Y'
              AND column_name NOT LIKE '%\_ID' ESCAPE '\'
       ) non_id_flds_marked_identifier,
       (
           SELECT
               LISTAGG(column_name,',') WITHIN GROUP (ORDER BY column_name)
             FROM user_views c
             JOIN user_tab_cols o
                ON c.view_name = o.table_name
            WHERE c.view_name = v.view_name
              AND NOT EXISTS (
               SELECT 1
                 FROM t_semantic_column
                WHERE object_name = c.view_name
                  AND o.column_name = column_name
           )
       ) col_not_in_sem
  FROM user_views v
 WHERE 1 = 1
 ORDER BY 1;
