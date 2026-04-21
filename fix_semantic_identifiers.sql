-- =============================================================
-- fix_semantic_identifiers.sql
-- 
-- Fixes two categories of semantic column metadata errors:
--
-- 1. Non-_ID fields incorrectly flagged as is_identifier = 'Y'
--    Business keys (codes, numbers, references) are human-readable
--    labels, not FK join keys. Unflagging them prevents the LLM
--    from using them as join columns between views.
--
-- 2. Missing FK columns that should be registered as identifiers
--    so the LLM can correctly join views together.
-- =============================================================

-- -------------------------------------------------------------
-- PART 1: Unflag non-_ID business keys
-- These are codes/numbers/references, not FK join keys
-- -------------------------------------------------------------
UPDATE t_semantic_column SET is_identifier = 'N'
WHERE (object_name, column_name) IN (
    ('V_CUSTOMER_ACCOUNT',       'CUSTOMER_ACCOUNT_NUMBER'),
    ('V_CUSTOMER_ORDER_SUMMARY', 'CUSTOMER_ACCOUNT_NUMBER'),
    ('V_INVENTORY_STATUS',       'SKU_CODE'),
    ('V_ORDER_DETAIL',           'CUSTOMER_ACCOUNT_NUMBER'),
    ('V_ORDER_DETAIL',           'ORDER_NUMBER'),
    ('V_ORDER_DETAIL',           'SKU_CODE'),
    ('V_ORDER_HEADER',           'ORDER_NUMBER'),
    ('V_ORGANIZATION',           'ORGANIZATION_CODE'),
    ('V_PAYMENT_TRANSACTION',    'PAYMENT_REFERENCE'),
    ('V_PRODUCT_MASTER',         'PRODUCT_CODE'),
    ('V_PRODUCT_SKU',            'SKU_CODE'),
    ('V_SHIPMENT_HEADER',        'SHIPMENT_NUMBER'),
    ('V_STATUS_CODE_LOOKUP',     'STATUS_CODE')
);

-- -------------------------------------------------------------
-- PART 2: Add missing FK columns to V_CUSTOMER_ACCOUNT
-- billing_address_id and shipping_address_id are the correct
-- join keys to V_ADDRESS_MASTER — their absence caused the
-- LLM to generate wrong joins for address-based queries
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_CUSTOMER_ACCOUNT', 'BILLING_ADDRESS_ID', 'Billing Address ID',
    'N', 'Y', 'N', 'Y', 91
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_CUSTOMER_ACCOUNT', 'SHIPPING_ADDRESS_ID', 'Shipping Address ID',
    'N', 'Y', 'N', 'Y', 92
);

-- -------------------------------------------------------------
-- PART 3: Add missing FK columns to V_CUSTOMER_ORDER_SUMMARY
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_CUSTOMER_ORDER_SUMMARY', 'CUSTOMER_ACCOUNT_ID', 'Customer Account ID',
    'N', 'Y', 'N', 'Y', 91
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_CUSTOMER_ORDER_SUMMARY', 'ORGANIZATION_ID', 'Organization ID',
    'N', 'Y', 'N', 'Y', 92
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_CUSTOMER_ORDER_SUMMARY', 'ORGANIZATION_CODE', 'Organization Code',
    'Y', 'N', 'N', 'Y', 93
);

-- -------------------------------------------------------------
-- PART 4: Add missing columns to V_ORDER_DETAIL
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_ORDER_DETAIL', 'CUSTOMER_ACCOUNT_ID', 'Customer Account ID',
    'N', 'Y', 'N', 'Y', 31
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_ORDER_DETAIL', 'CUSTOMER_TYPE', 'Customer Type',
    'Y', 'N', 'N', 'Y', 45
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_ORDER_DETAIL', 'ORGANIZATION_ID', 'Organization ID',
    'N', 'Y', 'N', 'Y', 51
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_ORDER_DETAIL', 'ORGANIZATION_CODE', 'Organization Code',
    'Y', 'N', 'N', 'Y', 52
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_ORDER_DETAIL', 'ORDER_LINE_ITEM_ID', 'Order Line Item ID',
    'N', 'Y', 'N', 'Y', 61
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_ORDER_DETAIL', 'LINE_NUMBER', 'Line Number',
    'Y', 'N', 'N', 'Y', 62
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_ORDER_DETAIL', 'LINE_STATUS_CODE', 'Line Status Code',
    'Y', 'N', 'N', 'Y', 145
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_ORDER_DETAIL', 'PRODUCT_SKU_ID', 'Product SKU ID',
    'N', 'Y', 'N', 'Y', 63
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_ORDER_DETAIL', 'PRODUCT_ID', 'Product ID',
    'N', 'Y', 'N', 'Y', 81
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_ORDER_DETAIL', 'PRODUCT_CODE', 'Product Code',
    'Y', 'N', 'N', 'Y', 82
);

-- -------------------------------------------------------------
-- PART 5: Add missing columns to V_INVENTORY_STATUS
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_INVENTORY_STATUS', 'INVENTORY_BALANCE_ID', 'Inventory Balance ID',
    'N', 'Y', 'N', 'Y', 91
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_INVENTORY_STATUS', 'PRODUCT_SKU_ID', 'Product SKU ID',
    'N', 'Y', 'N', 'Y', 92
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_INVENTORY_STATUS', 'PRODUCT_ID', 'Product ID',
    'N', 'Y', 'N', 'Y', 93
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_INVENTORY_STATUS', 'PRODUCT_CODE', 'Product Code',
    'Y', 'N', 'N', 'Y', 94
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_INVENTORY_STATUS', 'INVENTORY_STATUS_CODE', 'Inventory Status Code',
    'Y', 'N', 'N', 'Y', 95
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_INVENTORY_STATUS', 'SKU_STATUS_CODE', 'SKU Status Code',
    'Y', 'N', 'N', 'Y', 96
);

INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_INVENTORY_STATUS', 'PRODUCT_STATUS_CODE', 'Product Status Code',
    'Y', 'N', 'N', 'Y', 97
);

-- -------------------------------------------------------------
-- PART 6: Add missing columns to V_ORGANIZATION
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_ORGANIZATION', 'PRIMARY_ADDRESS_ID', 'Primary Address ID',
    'N', 'Y', 'N', 'Y', 91
);

-- -------------------------------------------------------------
-- PART 7: Add missing columns to V_PAYMENT_TRANSACTION
-- -------------------------------------------------------------
INSERT INTO t_semantic_column (
    object_name, column_name, business_name,
    is_human_readable, is_identifier, is_default_select,
    is_filterable, display_rank
) VALUES (
    'V_PAYMENT_TRANSACTION', 'PAYMENT_TRANSACTION_ID', 'Payment Transaction ID',
    'N', 'Y', 'N', 'Y', 91
);

COMMIT;

-- Quick verification
SELECT object_name,
       column_name,
       is_identifier
FROM t_semantic_column
WHERE is_identifier = 'Y'
ORDER BY object_name, column_name;
