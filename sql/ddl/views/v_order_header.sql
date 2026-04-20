CREATE OR REPLACE VIEW v_order_header AS
    SELECT oh.order_id,
           oh.order_number,
           oh.customer_account_id,
           oh.order_date,
           oh.status_code,
           oh.order_total_amount,
           oh.created_on
      FROM order_header oh;
