CREATE OR REPLACE VIEW v_customer_order_summary AS
    SELECT ca.customer_account_id,
           ca.customer_account_number,
           ca.customer_name,
           ca.customer_type,
           ca.status_code AS customer_status_code,
           org.organization_id,
           org.organization_code,
           org.organization_name,
           COUNT(DISTINCT oh.order_id) AS order_count,
           SUM(oh.order_total_amount) AS total_order_amount,
           MIN(oh.order_date) AS first_order_date,
           MAX(oh.order_date) AS most_recent_order_date
      FROM customer_account ca
      JOIN organization org
    ON org.organization_id = ca.organization_id
      LEFT JOIN order_header oh
    ON oh.customer_account_id = ca.customer_account_id
     GROUP BY ca.customer_account_id,
              ca.customer_account_number,
              ca.customer_name,
              ca.customer_type,
              ca.status_code,
              org.organization_id,
              org.organization_code,
              org.organization_name;
