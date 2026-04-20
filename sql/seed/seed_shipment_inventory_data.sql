pro    =========================================================
pro    Seeding shipment and inventory data
pro    =========================================================

-- -------------------------------------------------------------
-- shipment_header
-- -------------------------------------------------------------
INSERT INTO shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1001',
           (
               SELECT order_id
                 FROM order_header
                WHERE order_number = 'ORD-1001'
           ),
           DATE '2026-01-12',
           'ACTIVE',
           (
               SELECT shipping_address_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST1001'
           ),
           1648.00 );

INSERT INTO shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1002',
           (
               SELECT order_id
                 FROM order_header
                WHERE order_number = 'ORD-1002'
           ),
           DATE '2026-01-18',
           'ACTIVE',
           (
               SELECT shipping_address_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST1002'
           ),
           1718.00 );

INSERT INTO shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1003',
           (
               SELECT order_id
                 FROM order_header
                WHERE order_number = 'ORD-1003'
           ),
           DATE '2026-01-25',
           'ACTIVE',
           (
               SELECT shipping_address_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST2001'
           ),
           648.00 );

INSERT INTO shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1004',
           (
               SELECT order_id
                 FROM order_header
                WHERE order_number = 'ORD-1004'
           ),
           DATE '2026-02-05',
           'PENDING',
           (
               SELECT shipping_address_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST2002'
           ),
           219.00 );

INSERT INTO shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1005',
           (
               SELECT order_id
                 FROM order_header
                WHERE order_number = 'ORD-1005'
           ),
           DATE '2026-02-13',
           'ACTIVE',
           (
               SELECT shipping_address_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST3001'
           ),
           399.00 );

INSERT INTO shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1006',
           (
               SELECT order_id
                 FROM order_header
                WHERE order_number = 'ORD-1006'
           ),
           DATE '2026-02-23',
           'ACTIVE',
           (
               SELECT shipping_address_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST4001'
           ),
           1578.00 );

INSERT INTO shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1007',
           (
               SELECT order_id
                 FROM order_header
                WHERE order_number = 'ORD-1007'
           ),
           DATE '2026-03-03',
           'SUSPENDED',
           (
               SELECT shipping_address_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST4002'
           ),
           79.00 );

INSERT INTO shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1008',
           (
               SELECT order_id
                 FROM order_header
                WHERE order_number = 'ORD-1008'
           ),
           DATE '2026-03-12',
           'INACTIVE',
           (
               SELECT shipping_address_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST5001'
           ),
           1799.00 );

-- -------------------------------------------------------------
-- inventory_balance
-- -------------------------------------------------------------
INSERT INTO inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM product_sku
     WHERE sku_code = 'LAPTOP-13-256'
),
           'CLT-DC',
           14,
           5,
           'ACTIVE' );

INSERT INTO inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM product_sku
     WHERE sku_code = 'LAPTOP-15-512'
),
           'CLT-DC',
           8,
           4,
           'ACTIVE' );

INSERT INTO inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM product_sku
     WHERE sku_code = 'MONITOR-24-FHD'
),
           'CLT-DC',
           22,
           8,
           'ACTIVE' );

INSERT INTO inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM product_sku
     WHERE sku_code = 'MONITOR-27-QHD'
),
           'RDU-DC',
           6,
           5,
           'ACTIVE' );

INSERT INTO inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM product_sku
     WHERE sku_code = 'DOCK-USB-C-90W'
),
           'CLT-DC',
           11,
           6,
           'ACTIVE' );

INSERT INTO inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM product_sku
     WHERE sku_code = 'KEYBOARD-WL-BLK'
),
           'CLT-DC',
           30,
           10,
           'ACTIVE' );

INSERT INTO inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM product_sku
     WHERE sku_code = 'KEYBOARD-WL-WHT'
),
           'RDU-DC',
           18,
           8,
           'ACTIVE' );

INSERT INTO inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM product_sku
     WHERE sku_code = 'DESKTOP-I7-32GB'
),
           'CLT-DC',
           2,
           3,
           'INACTIVE' );

COMMIT;
