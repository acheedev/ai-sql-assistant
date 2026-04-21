-- -------------------------------------------------------------
-- V_SHIPMENT_HEADER
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_SHIPMENT_HEADER',
           'SHIPMENT_ID',
           'Shipment ID',
           'N',
           'Y',
           'N',
           'Y',
           90 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_SHIPMENT_HEADER',
           'SHIPMENT_NUMBER',
           'Shipment Number',
           'Y',
           'Y',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_SHIPMENT_HEADER',
           'ORDER_ID',
           'Order ID',
           'N',
           'Y',
           'N',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_SHIPMENT_HEADER',
           'SHIPMENT_DATE',
           'Shipment Date',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_SHIPMENT_HEADER',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_SHIPMENT_HEADER',
           'SHIP_TO_ADDRESS_ID',
           'Ship To Address ID',
           'N',
           'Y',
           'N',
           'Y',
           50 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_SHIPMENT_HEADER',
           'SHIPMENT_TOTAL_AMOUNT',
           'Shipment Total Amount',
           'Y',
           'N',
           'Y',
           'Y',
           60 );

-- -------------------------------------------------------------
-- V_INVENTORY_BALANCE
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_BALANCE',
           'INVENTORY_BALANCE_ID',
           'Inventory Balance ID',
           'N',
           'Y',
           'N',
           'Y',
           90 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_BALANCE',
           'PRODUCT_SKU_ID',
           'Product SKU ID',
           'N',
           'Y',
           'N',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_BALANCE',
           'LOCATION_CODE',
           'Location Code',
           'Y',
           'N',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_BALANCE',
           'QUANTITY_ON_HAND',
           'Quantity On Hand',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_BALANCE',
           'REORDER_THRESHOLD',
           'Reorder Threshold',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_BALANCE',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'N',
           'Y',
           'Y',
           50 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'ORDER_ID',
           'Order ID',
           'N',
           'Y',
           'N',
           'Y',
           5 );
COMMIT;

UPDATE t_semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_SHIPMENT_HEADER'
   AND column_name IN ( 'ORDER_ID',
                        'SHIP_TO_ADDRESS_ID' );
COMMIT;


-- -------------------------------------------------------------
-- V_ORDER_HEADER
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_HEADER',
           'ORDER_ID',
           'Order ID',
           'N',
           'Y',
           'N',
           'Y',
           90 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_HEADER',
           'ORDER_NUMBER',
           'Order Number',
           'Y',
           'Y',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_HEADER',
           'CUSTOMER_ACCOUNT_ID',
           'Customer Account ID',
           'N',
           'Y',
           'N',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_HEADER',
           'ORDER_DATE',
           'Order Date',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_HEADER',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_HEADER',
           'ORDER_TOTAL_AMOUNT',
           'Order Total Amount',
           'Y',
           'N',
           'Y',
           'Y',
           50 );

-- -------------------------------------------------------------
-- V_ORDER_LINE_ITEM
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_LINE_ITEM',
           'ORDER_LINE_ITEM_ID',
           'Order Line Item ID',
           'N',
           'Y',
           'N',
           'Y',
           90 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_LINE_ITEM',
           'ORDER_ID',
           'Order ID',
           'N',
           'Y',
           'N',
           'Y',
           80 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_LINE_ITEM',
           'LINE_NUMBER',
           'Line Number',
           'Y',
           'N',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_LINE_ITEM',
           'PRODUCT_SKU_ID',
           'Product SKU ID',
           'N',
           'Y',
           'N',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_LINE_ITEM',
           'QUANTITY',
           'Quantity',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_LINE_ITEM',
           'UNIT_PRICE',
           'Unit Price',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_LINE_ITEM',
           'LINE_TOTAL',
           'Line Total',
           'Y',
           'N',
           'Y',
           'Y',
           50 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_LINE_ITEM',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'N',
           'Y',
           'Y',
           60 );

-- -------------------------------------------------------------
-- V_PRODUCT_MASTER
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PRODUCT_MASTER',
           'PRODUCT_ID',
           'Product ID',
           'N',
           'Y',
           'N',
           'Y',
           90 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PRODUCT_MASTER',
           'PRODUCT_CODE',
           'Product Code',
           'Y',
           'Y',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PRODUCT_MASTER',
           'PRODUCT_NAME',
           'Product Name',
           'Y',
           'N',
           'Y',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PRODUCT_MASTER',
           'PRODUCT_DESCRIPTION',
           'Product Description',
           'Y',
           'N',
           'N',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PRODUCT_MASTER',
           'PRODUCT_CATEGORY',
           'Product Category',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PRODUCT_MASTER',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'N',
           'Y',
           'Y',
           50 );

-- -------------------------------------------------------------
-- V_PRODUCT_SKU
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PRODUCT_SKU',
           'PRODUCT_SKU_ID',
           'Product SKU ID',
           'N',
           'Y',
           'N',
           'Y',
           90 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PRODUCT_SKU',
           'PRODUCT_ID',
           'Product ID',
           'N',
           'Y',
           'N',
           'Y',
           80 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PRODUCT_SKU',
           'SKU_CODE',
           'SKU Code',
           'Y',
           'Y',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PRODUCT_SKU',
           'SKU_NAME',
           'SKU Name',
           'Y',
           'N',
           'Y',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PRODUCT_SKU',
           'SKU_DESCRIPTION',
           'SKU Description',
           'Y',
           'N',
           'N',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PRODUCT_SKU',
           'UNIT_PRICE',
           'Unit Price',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PRODUCT_SKU',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'N',
           'Y',
           'Y',
           50 );

-- -------------------------------------------------------------
-- V_ORDER_DETAIL
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'ORDER_NUMBER',
           'Order Number',
           'Y',
           'Y',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'ORDER_DATE',
           'Order Date',
           'Y',
           'N',
           'Y',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'CUSTOMER_ACCOUNT_NUMBER',
           'Customer Account Number',
           'Y',
           'Y',
           'Y',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'CUSTOMER_NAME',
           'Customer Name',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'ORGANIZATION_NAME',
           'Organization Name',
           'Y',
           'N',
           'Y',
           'Y',
           50 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'SKU_CODE',
           'SKU Code',
           'Y',
           'Y',
           'Y',
           'Y',
           60 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'SKU_NAME',
           'SKU Name',
           'Y',
           'N',
           'Y',
           'Y',
           70 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'PRODUCT_NAME',
           'Product Name',
           'Y',
           'N',
           'Y',
           'Y',
           80 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'PRODUCT_CATEGORY',
           'Product Category',
           'Y',
           'N',
           'Y',
           'Y',
           90 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'QUANTITY',
           'Quantity',
           'Y',
           'N',
           'Y',
           'Y',
           100 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'UNIT_PRICE',
           'Unit Price',
           'Y',
           'N',
           'Y',
           'Y',
           110 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'LINE_TOTAL',
           'Line Total',
           'Y',
           'N',
           'Y',
           'Y',
           120 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'ORDER_TOTAL_AMOUNT',
           'Order Total Amount',
           'Y',
           'N',
           'Y',
           'Y',
           130 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORDER_DETAIL',
           'ORDER_STATUS_CODE',
           'Order Status Code',
           'Y',
           'N',
           'N',
           'Y',
           140 );

-- -------------------------------------------------------------
-- V_CUSTOMER_ORDER_SUMMARY
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ORDER_SUMMARY',
           'CUSTOMER_ACCOUNT_NUMBER',
           'Customer Account Number',
           'Y',
           'Y',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ORDER_SUMMARY',
           'CUSTOMER_NAME',
           'Customer Name',
           'Y',
           'N',
           'Y',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ORDER_SUMMARY',
           'CUSTOMER_TYPE',
           'Customer Type',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ORDER_SUMMARY',
           'ORGANIZATION_NAME',
           'Organization Name',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ORDER_SUMMARY',
           'ORDER_COUNT',
           'Order Count',
           'Y',
           'N',
           'Y',
           'Y',
           50 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ORDER_SUMMARY',
           'TOTAL_ORDER_AMOUNT',
           'Total Order Amount',
           'Y',
           'N',
           'Y',
           'Y',
           60 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ORDER_SUMMARY',
           'FIRST_ORDER_DATE',
           'First Order Date',
           'Y',
           'N',
           'Y',
           'Y',
           70 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ORDER_SUMMARY',
           'MOST_RECENT_ORDER_DATE',
           'Most Recent Order Date',
           'Y',
           'N',
           'Y',
           'Y',
           80 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ORDER_SUMMARY',
           'CUSTOMER_STATUS_CODE',
           'Customer Status Code',
           'Y',
           'N',
           'N',
           'Y',
           90 );

-- -------------------------------------------------------------
-- V_INVENTORY_STATUS
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_STATUS',
           'LOCATION_CODE',
           'Location Code',
           'Y',
           'N',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_STATUS',
           'SKU_CODE',
           'SKU Code',
           'Y',
           'Y',
           'Y',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_STATUS',
           'SKU_NAME',
           'SKU Name',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_STATUS',
           'PRODUCT_NAME',
           'Product Name',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_STATUS',
           'PRODUCT_CATEGORY',
           'Product Category',
           'Y',
           'N',
           'Y',
           'Y',
           50 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_STATUS',
           'QUANTITY_ON_HAND',
           'Quantity On Hand',
           'Y',
           'N',
           'Y',
           'Y',
           60 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_STATUS',
           'REORDER_THRESHOLD',
           'Reorder Threshold',
           'Y',
           'N',
           'Y',
           'Y',
           70 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_STATUS',
           'INVENTORY_HEALTH',
           'Inventory Health',
           'Y',
           'N',
           'Y',
           'Y',
           80 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVENTORY_STATUS',
           'UNIT_PRICE',
           'Unit Price',
           'Y',
           'N',
           'N',
           'Y',
           90 );

-- -------------------------------------------------------------
-- V_INVOICE_HEADER
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVOICE_HEADER',
           'INVOICE_NUMBER',
           'Invoice Number',
           'Y',
           'Y',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVOICE_HEADER',
           'CUSTOMER_ACCOUNT_ID',
           'Customer Account ID',
           'N',
           'Y',
           'N',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVOICE_HEADER',
           'ORDER_ID',
           'Order ID',
           'N',
           'Y',
           'N',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVOICE_HEADER',
           'INVOICE_DATE',
           'Invoice Date',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVOICE_HEADER',
           'DUE_DATE',
           'Due Date',
           'Y',
           'N',
           'Y',
           'Y',
           50 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVOICE_HEADER',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'N',
           'Y',
           'Y',
           60 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVOICE_HEADER',
           'INVOICE_TOTAL_AMOUNT',
           'Invoice Total Amount',
           'Y',
           'N',
           'Y',
           'Y',
           70 );

-- -------------------------------------------------------------
-- V_PAYMENT_TRANSACTION
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PAYMENT_TRANSACTION',
           'PAYMENT_REFERENCE',
           'Payment Reference',
           'Y',
           'Y',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PAYMENT_TRANSACTION',
           'INVOICE_ID',
           'Invoice ID',
           'N',
           'Y',
           'N',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PAYMENT_TRANSACTION',
           'PAYMENT_DATE',
           'Payment Date',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PAYMENT_TRANSACTION',
           'PAYMENT_METHOD',
           'Payment Method',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PAYMENT_TRANSACTION',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'N',
           'Y',
           'Y',
           50 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_PAYMENT_TRANSACTION',
           'PAYMENT_AMOUNT',
           'Payment Amount',
           'Y',
           'N',
           'Y',
           'Y',
           60 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ACCOUNT',
           'CUSTOMER_ACCOUNT_ID',
           'Customer Account ID',
           'N',
           'Y',
           'N',
           'Y',
           90 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ACCOUNT',
           'CUSTOMER_ACCOUNT_NUMBER',
           'Customer Account Number',
           'Y',
           'Y',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ACCOUNT',
           'CUSTOMER_NAME',
           'Customer Name',
           'Y',
           'N',
           'Y',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ACCOUNT',
           'CUSTOMER_TYPE',
           'Customer Type',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ACCOUNT',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ACCOUNT',
           'ORGANIZATION_ID',
           'Organization ID',
           'N',
           'Y',
           'N',
           'Y',
           50 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORGANIZATION',
           'ORGANIZATION_ID',
           'Organization ID',
           'N',
           'Y',
           'N',
           'Y',
           90 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORGANIZATION',
           'ORGANIZATION_CODE',
           'Organization Code',
           'Y',
           'Y',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORGANIZATION',
           'ORGANIZATION_NAME',
           'Organization Name',
           'Y',
           'N',
           'Y',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORGANIZATION',
           'ORGANIZATION_TYPE',
           'Organization Type',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORGANIZATION',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ADDRESS_MASTER',
           'ADDRESS_ID',
           'Address ID',
           'N',
           'Y',
           'N',
           'Y',
           90 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ADDRESS_MASTER',
           'ADDRESS_LINE1',
           'Address Line 1',
           'Y',
           'N',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ADDRESS_MASTER',
           'CITY',
           'City',
           'Y',
           'N',
           'Y',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ADDRESS_MASTER',
           'STATE_PROVINCE',
           'State / Province',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ADDRESS_MASTER',
           'POSTAL_CODE',
           'Postal Code',
           'Y',
           'N',
           'N',
           'Y',
           40 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ADDRESS_MASTER',
           'COUNTRY_CODE',
           'Country Code',
           'Y',
           'N',
           'N',
           'Y',
           50 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_STATUS_CODE_LOOKUP',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'Y',
           'Y',
           'Y',
           10 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_STATUS_CODE_LOOKUP',
           'STATUS_TYPE',
           'Status Type',
           'Y',
           'N',
           'Y',
           'Y',
           20 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_STATUS_CODE_LOOKUP',
           'STATUS_DESCRIPTION',
           'Status Description',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_STATUS_CODE_LOOKUP',
           'IS_ACTIVE',
           'Is Active',
           'Y',
           'N',
           'N',
           'Y',
           40 );
COMMIT;

INSERT INTO t_semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_INVOICE_HEADER',
           'INVOICE_ID',
           'Invoice ID',
           'N',
           'Y',
           'N',
           'Y',
           5 );


UPDATE t_semantic_column
   SET
    is_identifier = 'N'
 WHERE object_name = 'V_INVOICE_HEADER'
   AND column_name = 'INVOICE_NUMBER';

COMMIT;
