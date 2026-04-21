CREATE OR REPLACE VIEW v_organization AS
    SELECT o.organization_id,
           o.organization_code,
           o.organization_name,
           o.organization_type,
           o.status_code,
           o.primary_address_id,
           o.created_on
      FROM t_organization o;
