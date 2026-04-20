-- -------------------------------------------------------------
-- V_ORDER_HEADER
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
) VALUES ( 'V_ORDER_HEADER',
           'ORDER_ID',
           'Order ID',
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
) VALUES ( 'V_ORDER_HEADER',
           'ORDER_NUMBER',
           'Order Number',
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
) VALUES ( 'V_ORDER_HEADER',
           'CUSTOMER_ACCOUNT_ID',
           'Customer Account ID',
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
) VALUES ( 'V_ORDER_HEADER',
           'ORDER_DATE',
           'Order Date',
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
) VALUES ( 'V_ORDER_HEADER',
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
INSERT INTO semantic_column (
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

INSERT INTO semantic_column (
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
           'N',
           'N',
           'Y',
           80 );

INSERT INTO semantic_column (
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

INSERT INTO semantic_column (
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
) VALUES ( 'V_ORDER_LINE_ITEM',
           'QUANTITY',
           'Quantity',
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
) VALUES ( 'V_ORDER_LINE_ITEM',
           'UNIT_PRICE',
           'Unit Price',
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
) VALUES ( 'V_ORDER_LINE_ITEM',
           'LINE_TOTAL',
           'Line Total',
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
) VALUES ( 'V_ORDER_LINE_ITEM',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'N',
           'Y',
           'Y',
           60 );
