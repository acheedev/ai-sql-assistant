-- V_SHIPMENT_HEADER (may already be done, safe to re-run)
UPDATE semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_SHIPMENT_HEADER'
   AND column_name IN ( 'ORDER_ID',
                        'SHIP_TO_ADDRESS_ID' );

-- V_ORDER_LINE_ITEM
UPDATE semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_ORDER_LINE_ITEM'
   AND column_name IN ( 'ORDER_ID',
                        'PRODUCT_SKU_ID' );

-- V_INVOICE_HEADER
UPDATE semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_INVOICE_HEADER'
   AND column_name IN ( 'ORDER_ID',
                        'CUSTOMER_ACCOUNT_ID' );

-- V_PAYMENT_TRANSACTION
UPDATE semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_PAYMENT_TRANSACTION'
   AND column_name = 'INVOICE_ID';

-- V_CUSTOMER_ACCOUNT
UPDATE semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_CUSTOMER_ACCOUNT'
   AND column_name = 'ORGANIZATION_ID';

-- V_ORDER_HEADER
UPDATE semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_ORDER_HEADER'
   AND column_name = 'CUSTOMER_ACCOUNT_ID';

-- V_INVENTORY_BALANCE
UPDATE semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_INVENTORY_BALANCE'
   AND column_name = 'PRODUCT_SKU_ID';

COMMIT;
