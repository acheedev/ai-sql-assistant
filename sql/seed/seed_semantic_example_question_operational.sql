INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show recent shipments',
           'V_SHIPMENT_HEADER',
           q'[
select
    shipment_number,
    order_id,
    shipment_date,
    status_code,
    shipment_total_amount
from v_shipment_header
order by shipment_date desc, shipment_number
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'List shipments by status',
           'V_SHIPMENT_HEADER',
           q'[
select
    status_code,
    shipment_number,
    shipment_date,
    shipment_total_amount
from v_shipment_header
order by status_code, shipment_date desc
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show shipment totals by order',
           'V_SHIPMENT_HEADER',
           q'[
select
    order_id,
    shipment_number,
    shipment_total_amount
from v_shipment_header
order by order_id, shipment_number
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show inventory by location',
           'V_INVENTORY_BALANCE',
           q'[
select
    location_code,
    product_sku_id,
    quantity_on_hand,
    reorder_threshold,
    status_code
from v_inventory_balance
order by location_code, product_sku_id
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show low inventory items',
           'V_INVENTORY_BALANCE',
           q'[
select
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold,
    status_code
from v_inventory_balance
where quantity_on_hand <= reorder_threshold
order by quantity_on_hand, product_sku_id
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show active inventory balances',
           'V_INVENTORY_BALANCE',
           q'[
select
    product_sku_id,
    location_code,
    quantity_on_hand,
    reorder_threshold
from v_inventory_balance
where status_code = 'ACTIVE'
order by location_code, product_sku_id
]',
           'Y' );
