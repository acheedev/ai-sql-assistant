CREATE OR REPLACE VIEW v_address_master AS
    SELECT am.address_id,
           am.address_line1,
           am.address_line2,
           am.city,
           am.state_province,
           am.postal_code,
           am.country_code,
           am.created_on
      FROM t_address_master am;
