CREATE OR REPLACE VIEW v_order_detail AS
    SELECT oh.order_id,
           oh.order_number,
           oh.order_date,
           oh.status_code AS order_status_code,
           oh.order_total_amount,
           ca.customer_account_id,
           ca.customer_account_number,
           ca.customer_name,
           ca.customer_type,
           org.organization_id,
           org.organization_code,
           org.organization_name,
           oli.order_line_item_id,
           oli.line_number,
           oli.quantity,
           oli.unit_price,
           oli.line_total,
           oli.status_code AS line_status_code,
           ps.product_sku_id,
           ps.sku_code,
           ps.sku_name,
           pm.product_id,
           pm.product_code,
           pm.product_name,
           pm.product_category
      FROM t_order_header oh
      JOIN t_customer_account ca
    ON ca.customer_account_id = oh.customer_account_id
      JOIN t_organization org
    ON org.organization_id = ca.organization_id
      JOIN t_order_line_item oli
    ON oli.order_id = oh.order_id
      JOIN t_product_sku ps
    ON ps.product_sku_id = oli.product_sku_id
      JOIN t_product_master pm
    ON pm.product_id = ps.product_id;
