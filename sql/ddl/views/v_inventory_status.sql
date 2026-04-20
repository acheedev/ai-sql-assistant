CREATE OR REPLACE VIEW v_inventory_status AS
    SELECT ib.inventory_balance_id,
           ib.location_code,
           ib.quantity_on_hand,
           ib.reorder_threshold,
           ib.status_code AS inventory_status_code,
           ps.product_sku_id,
           ps.sku_code,
           ps.sku_name,
           ps.unit_price,
           ps.status_code AS sku_status_code,
           pm.product_id,
           pm.product_code,
           pm.product_name,
           pm.product_category,
           pm.status_code AS product_status_code,
           CASE
               WHEN ib.quantity_on_hand = 0                     THEN
                   'OUT_OF_STOCK'
               WHEN ib.quantity_on_hand <= ib.reorder_threshold THEN
                   'LOW_STOCK'
               ELSE
                   'IN_STOCK'
           END AS inventory_health
      FROM inventory_balance ib
      JOIN product_sku ps
    ON ps.product_sku_id = ib.product_sku_id
      JOIN product_master pm
    ON pm.product_id = ps.product_id;
