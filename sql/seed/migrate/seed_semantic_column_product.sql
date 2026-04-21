-- -------------------------------------------------------------
-- V_PRODUCT_MASTER
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
) VALUES ( 'V_PRODUCT_MASTER',
           'PRODUCT_ID',
           'Product ID',
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
) VALUES ( 'V_PRODUCT_MASTER',
           'PRODUCT_CODE',
           'Product Code',
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
) VALUES ( 'V_PRODUCT_MASTER',
           'PRODUCT_NAME',
           'Product Name',
           'Y',
           'N',
           'Y',
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
) VALUES ( 'V_PRODUCT_MASTER',
           'PRODUCT_DESCRIPTION',
           'Product Description',
           'Y',
           'N',
           'N',
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
) VALUES ( 'V_PRODUCT_MASTER',
           'PRODUCT_CATEGORY',
           'Product Category',
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
INSERT INTO semantic_column (
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

INSERT INTO semantic_column (
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
) VALUES ( 'V_PRODUCT_SKU',
           'SKU_CODE',
           'SKU Code',
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
) VALUES ( 'V_PRODUCT_SKU',
           'SKU_NAME',
           'SKU Name',
           'Y',
           'N',
           'Y',
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
) VALUES ( 'V_PRODUCT_SKU',
           'SKU_DESCRIPTION',
           'SKU Description',
           'Y',
           'N',
           'N',
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
) VALUES ( 'V_PRODUCT_SKU',
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
) VALUES ( 'V_PRODUCT_SKU',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'N',
           'Y',
           'Y',
           50 );
