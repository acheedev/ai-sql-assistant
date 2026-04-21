-- -------------------------------------------------------------
-- V_SHIPMENT_HEADER
-- -------------------------------------------------------------
INSERT INTO semantic_column (
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

INSERT INTO semantic_column (
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

INSERT INTO semantic_column (
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
           'N',
           'N',
           'Y',
           20 );

INSERT INTO semantic_column (
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

INSERT INTO semantic_column (
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

INSERT INTO semantic_column (
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
           'N',
           'N',
           'Y',
           50 );

INSERT INTO semantic_column (
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
INSERT INTO semantic_column (
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

INSERT INTO semantic_column (
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
           'N',
           'N',
           'Y',
           20 );

INSERT INTO semantic_column (
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

INSERT INTO semantic_column (
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

INSERT INTO semantic_column (
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

INSERT INTO semantic_column (
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

INSERT INTO semantic_column (
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

UPDATE semantic_column
   SET
    is_identifier = 'Y'
 WHERE object_name = 'V_SHIPMENT_HEADER'
   AND column_name IN ( 'ORDER_ID',
                        'SHIP_TO_ADDRESS_ID' );
COMMIT;
