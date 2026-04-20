pro    =========================================================
pro    Seeding order data
pro    =========================================================

-- -------------------------------------------------------------
-- order_header
-- -------------------------------------------------------------
INSERT INTO order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1001',
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST1001'
           ),
           DATE '2026-01-10',
           'ACTIVE',
           1648.00 );

INSERT INTO order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1002',
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST1002'
           ),
           DATE '2026-01-15',
           'ACTIVE',
           1718.00 );

INSERT INTO order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1003',
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST2001'
           ),
           DATE '2026-01-22',
           'ACTIVE',
           648.00 );

INSERT INTO order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1004',
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST2002'
           ),
           DATE '2026-02-03',
           'PENDING',
           219.00 );

INSERT INTO order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1005',
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST3001'
           ),
           DATE '2026-02-11',
           'ACTIVE',
           399.00 );

INSERT INTO order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1006',
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST4001'
           ),
           DATE '2026-02-20',
           'ACTIVE',
           1578.00 );

INSERT INTO order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1007',
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST4002'
           ),
           DATE '2026-03-01',
           'SUSPENDED',
           79.00 );

INSERT INTO order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1008',
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST5001'
           ),
           DATE '2026-03-10',
           'INACTIVE',
           1799.00 );

-- -------------------------------------------------------------
-- order_line_item
-- -------------------------------------------------------------
INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1001'
),
           1,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'LAPTOP-13-256'
           ),
           1,
           1199.00,
           1199.00,
           'ACTIVE' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1001'
),
           2,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'MONITOR-24-FHD'
           ),
           1,
           249.00,
           249.00,
           'ACTIVE' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1001'
),
           3,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'DOCK-USB-C-90W'
           ),
           1,
           200.00,
           200.00,
           'ACTIVE' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1002'
),
           1,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'LAPTOP-15-512'
           ),
           1,
           1499.00,
           1499.00,
           'ACTIVE' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1002'
),
           2,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'KEYBOARD-WL-BLK'
           ),
           1,
           79.00,
           79.00,
           'ACTIVE' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1002'
),
           3,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'DOCK-USB-C-90W'
           ),
           1,
           140.00,
           140.00,
           'ACTIVE' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1003'
),
           1,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'MONITOR-27-QHD'
           ),
           1,
           399.00,
           399.00,
           'ACTIVE' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1003'
),
           2,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'KEYBOARD-WL-WHT'
           ),
           1,
           79.00,
           79.00,
           'ACTIVE' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1003'
),
           3,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'MONITOR-24-FHD'
           ),
           1,
           170.00,
           170.00,
           'ACTIVE' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1004'
),
           1,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'DOCK-USB-C-90W'
           ),
           1,
           219.00,
           219.00,
           'PENDING' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1005'
),
           1,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'MONITOR-27-QHD'
           ),
           1,
           399.00,
           399.00,
           'ACTIVE' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1006'
),
           1,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'LAPTOP-13-256'
           ),
           1,
           1199.00,
           1199.00,
           'ACTIVE' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1006'
),
           2,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'KEYBOARD-WL-BLK'
           ),
           1,
           79.00,
           79.00,
           'ACTIVE' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1006'
),
           3,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'MONITOR-24-FHD'
           ),
           1,
           300.00,
           300.00,
           'ACTIVE' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1007'
),
           1,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'KEYBOARD-WL-WHT'
           ),
           1,
           79.00,
           79.00,
           'SUSPENDED' );

INSERT INTO order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM order_header
     WHERE order_number = 'ORD-1008'
),
           1,
           (
               SELECT product_sku_id
                 FROM product_sku
                WHERE sku_code = 'DESKTOP-I7-32GB'
           ),
           1,
           1799.00,
           1799.00,
           'INACTIVE' );

COMMIT;
