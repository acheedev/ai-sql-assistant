pro    =========================================================
pro    Seeding business data
pro    =========================================================


-- organization, customer_account, product, address, status code,
-- order, order item, invoice_header, payment_transaction
-- -------------------------------------------------------------
-- organization
-- -------------------------------------------------------------
INSERT INTO t_organization (
    organization_code,
    organization_name,
    organization_type,
    status_code,
    primary_address_id
) VALUES ( 'ORG100',
           'Acme Manufacturing',
           'CUSTOMER',
           'ACTIVE',
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '100 Market Street'
                  AND city = 'Charlotte'
           ) );

INSERT INTO t_organization (
    organization_code,
    organization_name,
    organization_type,
    status_code,
    primary_address_id
) VALUES ( 'ORG200',
           'Blue Horizon Retail',
           'CUSTOMER',
           'ACTIVE',
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '500 Lake Drive'
                  AND city = 'Cornelius'
           ) );

INSERT INTO t_organization (
    organization_code,
    organization_name,
    organization_type,
    status_code,
    primary_address_id
) VALUES ( 'ORG300',
           'Northwind Logistics',
           'PARTNER',
           'PENDING',
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '12 Industrial Park Road'
                  AND city = 'Raleigh'
           ) );

INSERT INTO t_organization (
    organization_code,
    organization_name,
    organization_type,
    status_code,
    primary_address_id
) VALUES ( 'ORG400',
           'Summit Health Group',
           'CUSTOMER',
           'ACTIVE',
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '88 Innovation Way'
                  AND city = 'Austin'
           ) );

INSERT INTO t_organization (
    organization_code,
    organization_name,
    organization_type,
    status_code,
    primary_address_id
) VALUES ( 'ORG500',
           'Legacy Services',
           'CUSTOMER',
           'INACTIVE',
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '200 King Street West'
                  AND city = 'Toronto'
           ) );

-- -------------------------------------------------------------
-- customer_account
-- -------------------------------------------------------------
INSERT INTO t_customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST1001',
           (
               SELECT organization_id
                 FROM t_organization
                WHERE organization_code = 'ORG100'
           ),
           'Acme East Division',
           'B2B',
           'ACTIVE',
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '100 Market Street'
                  AND city = 'Charlotte'
           ),
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '250 Trade Avenue'
                  AND city = 'Charlotte'
           ) );

INSERT INTO t_customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST1002',
           (
               SELECT organization_id
                 FROM t_organization
                WHERE organization_code = 'ORG100'
           ),
           'Acme West Division',
           'B2B',
           'ACTIVE',
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '100 Market Street'
                  AND city = 'Charlotte'
           ),
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '15 Harbor Boulevard'
                  AND city = 'San Diego'
           ) );

INSERT INTO t_customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST2001',
           (
               SELECT organization_id
                 FROM t_organization
                WHERE organization_code = 'ORG200'
           ),
           'Blue Horizon Stores',
           'RETAIL',
           'ACTIVE',
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '500 Lake Drive'
                  AND city = 'Cornelius'
           ),
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '742 Evergreen Terrace'
                  AND city = 'Denver'
           ) );

INSERT INTO t_customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST2002',
           (
               SELECT organization_id
                 FROM t_organization
                WHERE organization_code = 'ORG200'
           ),
           'Blue Horizon Online',
           'ECOMMERCE',
           'PENDING',
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '500 Lake Drive'
                  AND city = 'Cornelius'
           ),
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '500 Lake Drive'
                  AND city = 'Cornelius'
           ) );

INSERT INTO t_customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST3001',
           (
               SELECT organization_id
                 FROM t_organization
                WHERE organization_code = 'ORG300'
           ),
           'Northwind Freight',
           'LOGISTICS',
           'PENDING',
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '12 Industrial Park Road'
                  AND city = 'Raleigh'
           ),
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '12 Industrial Park Road'
                  AND city = 'Raleigh'
           ) );

INSERT INTO t_customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST4001',
           (
               SELECT organization_id
                 FROM t_organization
                WHERE organization_code = 'ORG400'
           ),
           'Summit Primary Care',
           'HEALTHCARE',
           'ACTIVE',
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '88 Innovation Way'
                  AND city = 'Austin'
           ),
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '88 Innovation Way'
                  AND city = 'Austin'
           ) );

INSERT INTO t_customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST4002',
           (
               SELECT organization_id
                 FROM t_organization
                WHERE organization_code = 'ORG400'
           ),
           'Summit Specialty Clinic',
           'HEALTHCARE',
           'SUSPENDED',
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '88 Innovation Way'
                  AND city = 'Austin'
           ),
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '15 Harbor Boulevard'
                  AND city = 'San Diego'
           ) );

INSERT INTO t_customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST5001',
           (
               SELECT organization_id
                 FROM t_organization
                WHERE organization_code = 'ORG500'
           ),
           'Legacy Public Sector',
           'GOVERNMENT',
           'INACTIVE',
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '200 King Street West'
                  AND city = 'Toronto'
           ),
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '200 King Street West'
                  AND city = 'Toronto'
           ) );

INSERT INTO t_customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST5002',
           (
               SELECT organization_id
                 FROM t_organization
                WHERE organization_code = 'ORG500'
           ),
           'Legacy Enterprise',
           'B2B',
           'CLOSED',
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '200 King Street West'
                  AND city = 'Toronto'
           ),
           (
               SELECT address_id
                 FROM t_address_master
                WHERE address_line1 = '100 Market Street'
                  AND city = 'Charlotte'
           ) );

COMMIT;


pro    =========================================================
pro    Seeding product data
pro    =========================================================

-- -------------------------------------------------------------
-- product_master
-- -------------------------------------------------------------
INSERT INTO t_product_master (
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

INSERT INTO t_product_master (
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

INSERT INTO t_product_master (
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

INSERT INTO t_product_master (
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

INSERT INTO t_product_master (
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
INSERT INTO t_product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM t_product_master
     WHERE product_code = 'LAPTOP'
),
           'LAPTOP-13-256',
           'Business Laptop 13 256GB',
           '13-inch laptop with 256GB storage',
           1199.00,
           'ACTIVE' );

INSERT INTO t_product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM t_product_master
     WHERE product_code = 'LAPTOP'
),
           'LAPTOP-15-512',
           'Business Laptop 15 512GB',
           '15-inch laptop with 512GB storage',
           1499.00,
           'ACTIVE' );

INSERT INTO t_product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM t_product_master
     WHERE product_code = 'MONITOR'
),
           'MONITOR-24-FHD',
           'Desktop Monitor 24 FHD',
           '24-inch full HD monitor',
           249.00,
           'ACTIVE' );

INSERT INTO t_product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM t_product_master
     WHERE product_code = 'MONITOR'
),
           'MONITOR-27-QHD',
           'Desktop Monitor 27 QHD',
           '27-inch QHD monitor',
           399.00,
           'ACTIVE' );

INSERT INTO t_product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM t_product_master
     WHERE product_code = 'DOCK'
),
           'DOCK-USB-C-90W',
           'USB-C Dock 90W',
           'USB-C dock with 90W power delivery',
           219.00,
           'ACTIVE' );

INSERT INTO t_product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM t_product_master
     WHERE product_code = 'KEYBOARD'
),
           'KEYBOARD-WL-BLK',
           'Wireless Keyboard Black',
           'Wireless keyboard in black finish',
           79.00,
           'ACTIVE' );

INSERT INTO t_product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM t_product_master
     WHERE product_code = 'KEYBOARD'
),
           'KEYBOARD-WL-WHT',
           'Wireless Keyboard White',
           'Wireless keyboard in white finish',
           79.00,
           'ACTIVE' );

INSERT INTO t_product_sku (
    product_id,
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
) VALUES ( (
    SELECT product_id
      FROM t_product_master
     WHERE product_code = 'DESKTOP'
),
           'DESKTOP-I7-32GB',
           'Desktop Workstation i7 32GB',
           'Desktop workstation with Intel i7 CPU and 32GB RAM',
           1799.00,
           'INACTIVE' );

COMMIT;


pro =========================================================
pro    Seeding reference data
pro    =========================================================

-- -------------------------------------------------------------
-- status_code_lookup
-- -------------------------------------------------------------
INSERT INTO t_status_code_lookup (
    status_code,
    status_type,
    status_description,
    is_active
) VALUES ( 'ACTIVE',
           'GENERAL',
           'Active / currently in use',
           'Y' );

INSERT INTO t_status_code_lookup (
    status_code,
    status_type,
    status_description,
    is_active
) VALUES ( 'INACTIVE',
           'GENERAL',
           'Inactive / no longer in use',
           'Y' );

INSERT INTO t_status_code_lookup (
    status_code,
    status_type,
    status_description,
    is_active
) VALUES ( 'PENDING',
           'GENERAL',
           'Pending review or activation',
           'Y' );

INSERT INTO t_status_code_lookup (
    status_code,
    status_type,
    status_description,
    is_active
) VALUES ( 'SUSPENDED',
           'GENERAL',
           'Temporarily suspended',
           'Y' );

INSERT INTO t_status_code_lookup (
    status_code,
    status_type,
    status_description,
    is_active
) VALUES ( 'CLOSED',
           'GENERAL',
           'Closed / terminated',
           'Y' );

INSERT INTO t_status_code_lookup (
    status_code,
    status_type,
    status_description,
    is_active
) VALUES ( 'ARCHIVED',
           'GENERAL',
           'Archived for history only',
           'N' );

-- -------------------------------------------------------------
-- address_master
-- -------------------------------------------------------------
INSERT INTO t_address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '100 Market Street',
           'Suite 300',
           'Charlotte',
           'NC',
           '28202',
           'US' );

INSERT INTO t_address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '250 Trade Avenue',
           NULL,
           'Charlotte',
           'NC',
           '28203',
           'US' );

INSERT INTO t_address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '500 Lake Drive',
           NULL,
           'Cornelius',
           'NC',
           '28031',
           'US' );

INSERT INTO t_address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '742 Evergreen Terrace',
           NULL,
           'Denver',
           'NC',
           '28037',
           'US' );

INSERT INTO t_address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '12 Industrial Park Road',
           'Building B',
           'Raleigh',
           'NC',
           '27601',
           'US' );

INSERT INTO t_address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '88 Innovation Way',
           NULL,
           'Austin',
           'TX',
           '73301',
           'US' );

INSERT INTO t_address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '15 Harbor Boulevard',
           'Floor 5',
           'San Diego',
           'CA',
           '92101',
           'US' );

INSERT INTO t_address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '200 King Street West',
           'Suite 1900',
           'Toronto',
           'ON',
           'M5H 3T4',
           'CA' );

COMMIT;

pro    =========================================================
pro    Seeding order data
pro    =========================================================

-- -------------------------------------------------------------
-- order_header
-- -------------------------------------------------------------
INSERT INTO t_order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1001',
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST1001'
           ),
           DATE '2026-01-10',
           'ACTIVE',
           1648.00 );

INSERT INTO t_order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1002',
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST1002'
           ),
           DATE '2026-01-15',
           'ACTIVE',
           1718.00 );

INSERT INTO t_order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1003',
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST2001'
           ),
           DATE '2026-01-22',
           'ACTIVE',
           648.00 );

INSERT INTO t_order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1004',
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST2002'
           ),
           DATE '2026-02-03',
           'PENDING',
           219.00 );

INSERT INTO t_order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1005',
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST3001'
           ),
           DATE '2026-02-11',
           'ACTIVE',
           399.00 );

INSERT INTO t_order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1006',
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST4001'
           ),
           DATE '2026-02-20',
           'ACTIVE',
           1578.00 );

INSERT INTO t_order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1007',
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST4002'
           ),
           DATE '2026-03-01',
           'SUSPENDED',
           79.00 );

INSERT INTO t_order_header (
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
) VALUES ( 'ORD-1008',
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST5001'
           ),
           DATE '2026-03-10',
           'INACTIVE',
           1799.00 );

-- -------------------------------------------------------------
-- order_line_item
-- -------------------------------------------------------------
INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1001'
),
           1,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'LAPTOP-13-256'
           ),
           1,
           1199.00,
           1199.00,
           'ACTIVE' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1001'
),
           2,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'MONITOR-24-FHD'
           ),
           1,
           249.00,
           249.00,
           'ACTIVE' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1001'
),
           3,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'DOCK-USB-C-90W'
           ),
           1,
           200.00,
           200.00,
           'ACTIVE' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1002'
),
           1,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'LAPTOP-15-512'
           ),
           1,
           1499.00,
           1499.00,
           'ACTIVE' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1002'
),
           2,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'KEYBOARD-WL-BLK'
           ),
           1,
           79.00,
           79.00,
           'ACTIVE' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1002'
),
           3,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'DOCK-USB-C-90W'
           ),
           1,
           140.00,
           140.00,
           'ACTIVE' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1003'
),
           1,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'MONITOR-27-QHD'
           ),
           1,
           399.00,
           399.00,
           'ACTIVE' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1003'
),
           2,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'KEYBOARD-WL-WHT'
           ),
           1,
           79.00,
           79.00,
           'ACTIVE' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1003'
),
           3,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'MONITOR-24-FHD'
           ),
           1,
           170.00,
           170.00,
           'ACTIVE' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1004'
),
           1,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'DOCK-USB-C-90W'
           ),
           1,
           219.00,
           219.00,
           'PENDING' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1005'
),
           1,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'MONITOR-27-QHD'
           ),
           1,
           399.00,
           399.00,
           'ACTIVE' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1006'
),
           1,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'LAPTOP-13-256'
           ),
           1,
           1199.00,
           1199.00,
           'ACTIVE' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1006'
),
           2,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'KEYBOARD-WL-BLK'
           ),
           1,
           79.00,
           79.00,
           'ACTIVE' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1006'
),
           3,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'MONITOR-24-FHD'
           ),
           1,
           300.00,
           300.00,
           'ACTIVE' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1007'
),
           1,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'KEYBOARD-WL-WHT'
           ),
           1,
           79.00,
           79.00,
           'SUSPENDED' );

INSERT INTO t_order_line_item (
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
) VALUES ( (
    SELECT order_id
      FROM t_order_header
     WHERE order_number = 'ORD-1008'
),
           1,
           (
               SELECT product_sku_id
                 FROM t_product_sku
                WHERE sku_code = 'DESKTOP-I7-32GB'
           ),
           1,
           1799.00,
           1799.00,
           'INACTIVE' );

COMMIT;


pro    =========================================================
pro    Seeding finance data
pro    =========================================================

-- -------------------------------------------------------------
-- invoice_header
-- -------------------------------------------------------------
INSERT INTO t_invoice_header (
    invoice_number,
    order_id,
    customer_account_id,
    invoice_date,
    due_date,
    status_code,
    invoice_total_amount
) VALUES ( 'INV-1001',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1001'
           ),
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST1001'
           ),
           DATE '2026-01-13',
           DATE '2026-02-12',
           'ACTIVE',
           1648.00 );

INSERT INTO t_invoice_header (
    invoice_number,
    order_id,
    customer_account_id,
    invoice_date,
    due_date,
    status_code,
    invoice_total_amount
) VALUES ( 'INV-1002',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1002'
           ),
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST1002'
           ),
           DATE '2026-01-19',
           DATE '2026-02-18',
           'ACTIVE',
           1718.00 );

INSERT INTO t_invoice_header (
    invoice_number,
    order_id,
    customer_account_id,
    invoice_date,
    due_date,
    status_code,
    invoice_total_amount
) VALUES ( 'INV-1003',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1003'
           ),
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST2001'
           ),
           DATE '2026-01-26',
           DATE '2026-02-25',
           'ACTIVE',
           648.00 );

INSERT INTO t_invoice_header (
    invoice_number,
    order_id,
    customer_account_id,
    invoice_date,
    due_date,
    status_code,
    invoice_total_amount
) VALUES ( 'INV-1004',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1004'
           ),
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST2002'
           ),
           DATE '2026-02-06',
           DATE '2026-03-08',
           'PENDING',
           219.00 );

INSERT INTO t_invoice_header (
    invoice_number,
    order_id,
    customer_account_id,
    invoice_date,
    due_date,
    status_code,
    invoice_total_amount
) VALUES ( 'INV-1005',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1005'
           ),
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST3001'
           ),
           DATE '2026-02-14',
           DATE '2026-03-16',
           'ACTIVE',
           399.00 );

INSERT INTO t_invoice_header (
    invoice_number,
    order_id,
    customer_account_id,
    invoice_date,
    due_date,
    status_code,
    invoice_total_amount
) VALUES ( 'INV-1006',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1006'
           ),
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST4001'
           ),
           DATE '2026-02-24',
           DATE '2026-03-26',
           'ACTIVE',
           1578.00 );

INSERT INTO t_invoice_header (
    invoice_number,
    order_id,
    customer_account_id,
    invoice_date,
    due_date,
    status_code,
    invoice_total_amount
) VALUES ( 'INV-1007',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1007'
           ),
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST4002'
           ),
           DATE '2026-03-04',
           DATE '2026-04-03',
           'SUSPENDED',
           79.00 );

INSERT INTO t_invoice_header (
    invoice_number,
    order_id,
    customer_account_id,
    invoice_date,
    due_date,
    status_code,
    invoice_total_amount
) VALUES ( 'INV-1008',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1008'
           ),
           (
               SELECT customer_account_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST5001'
           ),
           DATE '2026-03-13',
           DATE '2026-04-12',
           'INACTIVE',
           1799.00 );

-- -------------------------------------------------------------
-- payment_transaction
-- -------------------------------------------------------------
INSERT INTO t_payment_transaction (
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    status_code,
    payment_amount
) VALUES ( 'PAY-1001',
           (
               SELECT invoice_id
                 FROM t_invoice_header
                WHERE invoice_number = 'INV-1001'
           ),
           DATE '2026-01-20',
           'ACH',
           'ACTIVE',
           1648.00 );

INSERT INTO t_payment_transaction (
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    status_code,
    payment_amount
) VALUES ( 'PAY-1002',
           (
               SELECT invoice_id
                 FROM t_invoice_header
                WHERE invoice_number = 'INV-1002'
           ),
           DATE '2026-01-28',
           'WIRE',
           'ACTIVE',
           1000.00 );

INSERT INTO t_payment_transaction (
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    status_code,
    payment_amount
) VALUES ( 'PAY-1003',
           (
               SELECT invoice_id
                 FROM t_invoice_header
                WHERE invoice_number = 'INV-1002'
           ),
           DATE '2026-02-05',
           'WIRE',
           'ACTIVE',
           718.00 );

INSERT INTO t_payment_transaction (
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    status_code,
    payment_amount
) VALUES ( 'PAY-1004',
           (
               SELECT invoice_id
                 FROM t_invoice_header
                WHERE invoice_number = 'INV-1003'
           ),
           DATE '2026-02-01',
           'CREDIT_CARD',
           'ACTIVE',
           648.00 );

INSERT INTO t_payment_transaction (
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    status_code,
    payment_amount
) VALUES ( 'PAY-1005',
           (
               SELECT invoice_id
                 FROM t_invoice_header
                WHERE invoice_number = 'INV-1005'
           ),
           DATE '2026-02-20',
           'ACH',
           'ACTIVE',
           399.00 );

INSERT INTO t_payment_transaction (
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    status_code,
    payment_amount
) VALUES ( 'PAY-1006',
           (
               SELECT invoice_id
                 FROM t_invoice_header
                WHERE invoice_number = 'INV-1006'
           ),
           DATE '2026-03-01',
           'ACH',
           'ACTIVE',
           1000.00 );

INSERT INTO t_payment_transaction (
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    status_code,
    payment_amount
) VALUES ( 'PAY-1007',
           (
               SELECT invoice_id
                 FROM t_invoice_header
                WHERE invoice_number = 'INV-1006'
           ),
           DATE '2026-03-15',
           'ACH',
           'ACTIVE',
           578.00 );

COMMIT;

pro    =========================================================
pro    Seeding shipment and inventory data
pro    =========================================================

-- -------------------------------------------------------------
-- shipment_header
-- -------------------------------------------------------------
INSERT INTO t_shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1001',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1001'
           ),
           DATE '2026-01-12',
           'ACTIVE',
           (
               SELECT shipping_address_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST1001'
           ),
           1648.00 );

INSERT INTO t_shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1002',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1002'
           ),
           DATE '2026-01-18',
           'ACTIVE',
           (
               SELECT shipping_address_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST1002'
           ),
           1718.00 );

INSERT INTO t_shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1003',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1003'
           ),
           DATE '2026-01-25',
           'ACTIVE',
           (
               SELECT shipping_address_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST2001'
           ),
           648.00 );

INSERT INTO t_shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1004',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1004'
           ),
           DATE '2026-02-05',
           'PENDING',
           (
               SELECT shipping_address_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST2002'
           ),
           219.00 );

INSERT INTO t_shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1005',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1005'
           ),
           DATE '2026-02-13',
           'ACTIVE',
           (
               SELECT shipping_address_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST3001'
           ),
           399.00 );

INSERT INTO t_shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1006',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1006'
           ),
           DATE '2026-02-23',
           'ACTIVE',
           (
               SELECT shipping_address_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST4001'
           ),
           1578.00 );

INSERT INTO t_shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1007',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1007'
           ),
           DATE '2026-03-03',
           'SUSPENDED',
           (
               SELECT shipping_address_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST4002'
           ),
           79.00 );

INSERT INTO t_shipment_header (
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    ship_to_address_id,
    shipment_total_amount
) VALUES ( 'SHP-1008',
           (
               SELECT order_id
                 FROM t_order_header
                WHERE order_number = 'ORD-1008'
           ),
           DATE '2026-03-12',
           'INACTIVE',
           (
               SELECT shipping_address_id
                 FROM t_customer_account
                WHERE customer_account_number = 'CUST5001'
           ),
           1799.00 );

-- -------------------------------------------------------------
-- inventory_balance
-- -------------------------------------------------------------
INSERT INTO t_inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM t_product_sku
     WHERE sku_code = 'LAPTOP-13-256'
),
           'CLT-DC',
           14,
           5,
           'ACTIVE' );

INSERT INTO t_inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM t_product_sku
     WHERE sku_code = 'LAPTOP-15-512'
),
           'CLT-DC',
           8,
           4,
           'ACTIVE' );

INSERT INTO t_inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM t_product_sku
     WHERE sku_code = 'MONITOR-24-FHD'
),
           'CLT-DC',
           22,
           8,
           'ACTIVE' );

INSERT INTO t_inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM t_product_sku
     WHERE sku_code = 'MONITOR-27-QHD'
),
           'RDU-DC',
           6,
           5,
           'ACTIVE' );

INSERT INTO t_inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM t_product_sku
     WHERE sku_code = 'DOCK-USB-C-90W'
),
           'CLT-DC',
           11,
           6,
           'ACTIVE' );

INSERT INTO t_inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM t_product_sku
     WHERE sku_code = 'KEYBOARD-WL-BLK'
),
           'CLT-DC',
           30,
           10,
           'ACTIVE' );

INSERT INTO t_inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM t_product_sku
     WHERE sku_code = 'KEYBOARD-WL-WHT'
),
           'RDU-DC',
           18,
           8,
           'ACTIVE' );

INSERT INTO t_inventory_balance (
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
) VALUES ( (
    SELECT product_sku_id
      FROM t_product_sku
     WHERE sku_code = 'DESKTOP-I7-32GB'
),
           'CLT-DC',
           2,
           3,
           'INACTIVE' );

COMMIT;
