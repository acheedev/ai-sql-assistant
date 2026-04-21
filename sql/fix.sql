UPDATE t_semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_SHIPMENT_HEADER'
   AND column_name IN ( 'ORDER_ID',
                        'SHIP_TO_ADDRESS_ID' );

UPDATE t_semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_ORDER_LINE_ITEM'
   AND column_name IN ( 'ORDER_ID',
                        'PRODUCT_SKU_ID' );

UPDATE t_semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_INVOICE_HEADER'
   AND column_name IN ( 'ORDER_ID',
                        'CUSTOMER_ACCOUNT_ID' );

UPDATE t_semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_PAYMENT_TRANSACTION'
   AND column_name = 'INVOICE_ID';

UPDATE t_semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_CUSTOMER_ACCOUNT'
   AND column_name = 'ORGANIZATION_ID';

UPDATE t_semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_ORDER_HEADER'
   AND column_name = 'CUSTOMER_ACCOUNT_ID';

UPDATE t_semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_INVENTORY_BALANCE'
   AND column_name = 'PRODUCT_SKU_ID';

COMMIT;

UPDATE t_semantic_object
   SET
    short_description = 'Line-item level view. One row per order line. Use when SKU, product, quantity, or pricing detail is needed. For order-level queries without line detail, prefer V_ORDER_HEADER or V_CUSTOMER_ORDER_SUMMARY.'
 WHERE object_name = 'V_ORDER_DETAIL';

COMMIT;
