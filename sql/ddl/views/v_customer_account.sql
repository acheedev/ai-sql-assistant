CREATE OR REPLACE VIEW v_customer_account AS
    SELECT ca.customer_account_id,
           ca.customer_account_number,
           ca.organization_id,
           ca.customer_name,
           ca.customer_type,
           ca.status_code,
           ca.billing_address_id,
           ca.shipping_address_id,
           ca.created_on
      FROM t_customer_account ca;
