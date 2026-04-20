pro    =========================================================
pro    Seeding product data
pro    =========================================================

-- -------------------------------------------------------------
-- product_master
-- -------------------------------------------------------------
INSERT INTO product_master (
    product_code,
    product_name,
    product_description,
    product_category,
    status_code
) VALUES ( 'LAPTOP',
           'Business Laptop',
           'Portable business-class laptop product line',
           'HARDWARE',
           'ACTIVE' );

INSERT INTO product_master (
    product_code,
    product_name,
    product_description,
    product_category,
    status_code
) VALUES ( 'MONITOR',
           'Desktop Monitor',
           'External display product line',
           'HARDWARE',
           'ACTIVE' );

INSERT INTO product_master (
    product_code,
    product_name,
    product_description,
    product_category,
    status_code
) VALUES ( 'DOCK',
           'USB-C Docking Station',
           'Docking station for laptop connectivity and peripherals',
           'ACCESSORY',
           'ACTIVE' );

INSERT INTO product_master (
    product_code,
    product_name,
    product_description,
    product_category,
    status_code
) VALUES ( 'KEYBOARD',
           'Wireless Keyboard',
           'Wireless keyboard product line',
           'ACCESSORY',
           'ACTIVE' );

INSERT INTO product_master (
    product_code,
    product_name,
    product_description,
    product_category,
    status_code
) VALUES ( 'DESKTOP',
           'Desktop Workstation',
           'High-performance desktop workstation product line',
           'HARDWARE',
           'INACTIVE' );

-- -------------------------------------------------------------
-- product_sku
-- -------------------------------------------------------------
INSERT INTO product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM product_master
     WHERE product_code = 'LAPTOP'
),
           'LAPTOP-13-256',
           'Business Laptop 13 256GB',
           '13-inch laptop with 256GB storage',
           1199.00,
           'ACTIVE' );

INSERT INTO product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM product_master
     WHERE product_code = 'LAPTOP'
),
           'LAPTOP-15-512',
           'Business Laptop 15 512GB',
           '15-inch laptop with 512GB storage',
           1499.00,
           'ACTIVE' );

INSERT INTO product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM product_master
     WHERE product_code = 'MONITOR'
),
           'MONITOR-24-FHD',
           'Desktop Monitor 24 FHD',
           '24-inch full HD monitor',
           249.00,
           'ACTIVE' );

INSERT INTO product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM product_master
     WHERE product_code = 'MONITOR'
),
           'MONITOR-27-QHD',
           'Desktop Monitor 27 QHD',
           '27-inch QHD monitor',
           399.00,
           'ACTIVE' );

INSERT INTO product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM product_master
     WHERE product_code = 'DOCK'
),
           'DOCK-USB-C-90W',
           'USB-C Dock 90W',
           'USB-C dock with 90W power delivery',
           219.00,
           'ACTIVE' );

INSERT INTO product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM product_master
     WHERE product_code = 'KEYBOARD'
),
           'KEYBOARD-WL-BLK',
           'Wireless Keyboard Black',
           'Wireless keyboard in black finish',
           79.00,
           'ACTIVE' );

INSERT INTO product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM product_master
     WHERE product_code = 'KEYBOARD'
),
           'KEYBOARD-WL-WHT',
           'Wireless Keyboard White',
           'Wireless keyboard in white finish',
           79.00,
           'ACTIVE' );

INSERT INTO product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM product_master
     WHERE product_code = 'DESKTOP'
),
           'DESKTOP-I7-32GB',
           'Desktop Workstation i7 32GB',
           'Desktop workstation with Intel i7 CPU and 32GB RAM',
           1799.00,
           'INACTIVE' );

COMMIT;
