CREATE OR REPLACE VIEW v_product_master AS
    SELECT pm.product_id,
           pm.product_code,
           pm.product_name,
           pm.product_description,
           pm.product_category,
           pm.status_code,
           pm.created_on
      FROM product_master pm;
