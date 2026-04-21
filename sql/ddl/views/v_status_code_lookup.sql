CREATE OR REPLACE VIEW v_status_code_lookup AS
    SELECT scl.status_code,
           scl.status_type,
           scl.status_description,
           scl.is_active,
           scl.created_on
      FROM t_status_code_lookup scl;
