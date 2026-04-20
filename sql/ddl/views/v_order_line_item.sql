CREATE OR REPLACE VIEW v_order_line_item AS
    SELECT oli.order_line_item_id,
           oli.order_id,
           oli.line_number,
           oli.product_sku_id,
           oli.quantity,
           oli.unit_price,
           oli.line_total,
           oli.status_code,
           oli.created_on
      FROM order_line_item oli;
