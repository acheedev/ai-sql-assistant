INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show all active products',
           'V_PRODUCT_MASTER',
           q'[
select
    product_code,
    product_name,
    product_category,
    status_code
from v_product_master
where status_code = 'ACTIVE'
order by product_name
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'List products by category',
           'V_PRODUCT_MASTER',
           q'[
select
    product_category,
    product_code,
    product_name,
    status_code
from v_product_master
order by product_category, product_name
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show all active SKUs with prices',
           'V_PRODUCT_SKU',
           q'[
select
    sku_code,
    sku_name,
    unit_price,
    status_code
from v_product_sku
where status_code = 'ACTIVE'
order by sku_name
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Find SKU by code',
           'V_PRODUCT_SKU',
           q'[
select
    sku_code,
    sku_name,
    sku_description,
    unit_price,
    status_code
from v_product_sku
where sku_code = :sku_code
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show SKU prices',
           'V_PRODUCT_SKU',
           q'[
select
    sku_code,
    sku_name,
    unit_price
from v_product_sku
order by unit_price desc, sku_name
]',
           'Y' );
