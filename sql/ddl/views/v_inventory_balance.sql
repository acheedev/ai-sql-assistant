CREATE OR REPLACE VIEW v_inventory_balance AS
    SELECT ib.inventory_balance_id,
           ib.product_sku_id,
           ib.location_code,
           ib.quantity_on_hand,
           ib.reorder_threshold,
           ib.status_code,
           ib.created_on
      FROM t_inventory_balance ib;
