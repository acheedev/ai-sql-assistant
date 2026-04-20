pro    =========================================================
pro    Seeding finance data
pro    =========================================================

-- -------------------------------------------------------------
-- invoice_header
-- -------------------------------------------------------------
INSERT INTO invoice_header (
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
                 FROM order_header
                WHERE order_number = 'ORD-1001'
           ),
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST1001'
           ),
           DATE '2026-01-13',
           DATE '2026-02-12',
           'ACTIVE',
           1648.00 );

INSERT INTO invoice_header (
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
                 FROM order_header
                WHERE order_number = 'ORD-1002'
           ),
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST1002'
           ),
           DATE '2026-01-19',
           DATE '2026-02-18',
           'ACTIVE',
           1718.00 );

INSERT INTO invoice_header (
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
                 FROM order_header
                WHERE order_number = 'ORD-1003'
           ),
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST2001'
           ),
           DATE '2026-01-26',
           DATE '2026-02-25',
           'ACTIVE',
           648.00 );

INSERT INTO invoice_header (
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
                 FROM order_header
                WHERE order_number = 'ORD-1004'
           ),
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST2002'
           ),
           DATE '2026-02-06',
           DATE '2026-03-08',
           'PENDING',
           219.00 );

INSERT INTO invoice_header (
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
                 FROM order_header
                WHERE order_number = 'ORD-1005'
           ),
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST3001'
           ),
           DATE '2026-02-14',
           DATE '2026-03-16',
           'ACTIVE',
           399.00 );

INSERT INTO invoice_header (
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
                 FROM order_header
                WHERE order_number = 'ORD-1006'
           ),
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST4001'
           ),
           DATE '2026-02-24',
           DATE '2026-03-26',
           'ACTIVE',
           1578.00 );

INSERT INTO invoice_header (
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
                 FROM order_header
                WHERE order_number = 'ORD-1007'
           ),
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST4002'
           ),
           DATE '2026-03-04',
           DATE '2026-04-03',
           'SUSPENDED',
           79.00 );

INSERT INTO invoice_header (
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
                 FROM order_header
                WHERE order_number = 'ORD-1008'
           ),
           (
               SELECT customer_account_id
                 FROM customer_account
                WHERE customer_account_number = 'CUST5001'
           ),
           DATE '2026-03-13',
           DATE '2026-04-12',
           'INACTIVE',
           1799.00 );

-- -------------------------------------------------------------
-- payment_transaction
-- -------------------------------------------------------------
INSERT INTO payment_transaction (
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    status_code,
    payment_amount
) VALUES ( 'PAY-1001',
           (
               SELECT invoice_id
                 FROM invoice_header
                WHERE invoice_number = 'INV-1001'
           ),
           DATE '2026-01-20',
           'ACH',
           'ACTIVE',
           1648.00 );

INSERT INTO payment_transaction (
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    status_code,
    payment_amount
) VALUES ( 'PAY-1002',
           (
               SELECT invoice_id
                 FROM invoice_header
                WHERE invoice_number = 'INV-1002'
           ),
           DATE '2026-01-28',
           'WIRE',
           'ACTIVE',
           1000.00 );

INSERT INTO payment_transaction (
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    status_code,
    payment_amount
) VALUES ( 'PAY-1003',
           (
               SELECT invoice_id
                 FROM invoice_header
                WHERE invoice_number = 'INV-1002'
           ),
           DATE '2026-02-05',
           'WIRE',
           'ACTIVE',
           718.00 );

INSERT INTO payment_transaction (
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    status_code,
    payment_amount
) VALUES ( 'PAY-1004',
           (
               SELECT invoice_id
                 FROM invoice_header
                WHERE invoice_number = 'INV-1003'
           ),
           DATE '2026-02-01',
           'CREDIT_CARD',
           'ACTIVE',
           648.00 );

INSERT INTO payment_transaction (
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    status_code,
    payment_amount
) VALUES ( 'PAY-1005',
           (
               SELECT invoice_id
                 FROM invoice_header
                WHERE invoice_number = 'INV-1005'
           ),
           DATE '2026-02-20',
           'ACH',
           'ACTIVE',
           399.00 );

INSERT INTO payment_transaction (
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    status_code,
    payment_amount
) VALUES ( 'PAY-1006',
           (
               SELECT invoice_id
                 FROM invoice_header
                WHERE invoice_number = 'INV-1006'
           ),
           DATE '2026-03-01',
           'ACH',
           'ACTIVE',
           1000.00 );

INSERT INTO payment_transaction (
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    status_code,
    payment_amount
) VALUES ( 'PAY-1007',
           (
               SELECT invoice_id
                 FROM invoice_header
                WHERE invoice_number = 'INV-1006'
           ),
           DATE '2026-03-15',
           'ACH',
           'ACTIVE',
           578.00 );

COMMIT;
