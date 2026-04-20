CREATE OR REPLACE VIEW v_product_sku AS
    SELECT ps.product_sku_id,
           ps.product_id,
           ps.sku_code,
           ps.sku_name,
           ps.sku_description,
           ps.unit_price,
           ps.status_code,
           ps.created_on
      FROM product_sku ps;
