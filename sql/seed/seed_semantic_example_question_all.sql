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

COMMIT;

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show recent orders',
           'V_ORDER_HEADER',
           q'[
select
    order_number,
    customer_account_id,
    order_date,
    status_code,
    order_total_amount
from v_order_header
order by order_date desc, order_number
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'List orders by customer',
           'V_ORDER_HEADER',
           q'[
select
    customer_account_id,
    order_number,
    order_date,
    order_total_amount,
    status_code
from v_order_header
order by customer_account_id, order_date desc
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show total order amount by status',
           'V_ORDER_HEADER',
           q'[
select
    status_code,
    sum(order_total_amount) as total_order_amount
from v_order_header
group by status_code
order by status_code
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show order line items',
           'V_ORDER_LINE_ITEM',
           q'[
select
    order_id,
    line_number,
    product_sku_id,
    quantity,
    unit_price,
    line_total,
    status_code
from v_order_line_item
order by order_id, line_number
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show total quantity ordered by SKU',
           'V_ORDER_LINE_ITEM',
           q'[
select
    product_sku_id,
    sum(quantity) as total_quantity
from v_order_line_item
group by product_sku_id
order by total_quantity desc, product_sku_id
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show line totals by order',
           'V_ORDER_LINE_ITEM',
           q'[
select
    order_id,
    line_number,
    line_total
from v_order_line_item
order by order_id, line_number
]',
           'Y' );

COMMIT;

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

COMMIT;

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show order detail by customer',
           'V_ORDER_DETAIL',
           q'[
select
    order_number,
    order_date,
    customer_account_number,
    customer_name,
    sku_code,
    sku_name,
    quantity,
    line_total
from v_order_detail
order by order_date desc, order_number, line_number
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show top customers by order amount',
           'V_CUSTOMER_ORDER_SUMMARY',
           q'[
select
    customer_account_number,
    customer_name,
    organization_name,
    order_count,
    total_order_amount
from v_customer_order_summary
order by total_order_amount desc, customer_name
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show customers with no orders',
           'V_CUSTOMER_ORDER_SUMMARY',
           q'[
select
    customer_account_number,
    customer_name,
    organization_name,
    order_count,
    total_order_amount
from v_customer_order_summary
where order_count = 0
order by customer_name
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show low stock items by location',
           'V_INVENTORY_STATUS',
           q'[
select
    location_code,
    sku_code,
    sku_name,
    product_name,
    quantity_on_hand,
    reorder_threshold,
    inventory_health
from v_inventory_status
where inventory_health in ('LOW_STOCK', 'OUT_OF_STOCK')
order by location_code, quantity_on_hand, sku_code
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show invoices by due date',
           'V_INVOICE_HEADER',
           q'[
select
    invoice_number,
    customer_account_id,
    invoice_date,
    due_date,
    status_code,
    invoice_total_amount
from v_invoice_header
order by due_date, invoice_number
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show total invoice amount by status',
           'V_INVOICE_HEADER',
           q'[
select
    status_code,
    sum(invoice_total_amount) as total_invoice_amount
from v_invoice_header
group by status_code
order by status_code
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show payments by method',
           'V_PAYMENT_TRANSACTION',
           q'[
select
    payment_method,
    count(*) as payment_count,
    sum(payment_amount) as total_payment_amount
from v_payment_transaction
group by payment_method
order by total_payment_amount desc, payment_method
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show payments by date',
           'V_PAYMENT_TRANSACTION',
           q'[
select
    payment_reference,
    invoice_id,
    payment_date,
    payment_method,
    payment_amount,
    status_code
from v_payment_transaction
order by payment_date desc, payment_reference
]',
           'Y' );

COMMIT;

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show active customer accounts',
           'V_CUSTOMER_ACCOUNT',
           q'[
select
    customer_account_number,
    customer_name,
    customer_type,
    status_code
from v_customer_account
where status_code = 'ACTIVE'
order by customer_name
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'List customers by organization',
           'V_CUSTOMER_ACCOUNT',
           q'[
select
    organization_id,
    customer_account_number,
    customer_name
from v_customer_account
order by organization_id, customer_name
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Find organization by code',
           'V_ORGANIZATION',
           q'[
select
    organization_code,
    organization_name,
    organization_type,
    status_code
from v_organization
where organization_code = :organization_code
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'Show all active status codes',
           'V_STATUS_CODE_LOOKUP',
           q'[
select
    status_code,
    status_type,
    status_description
from v_status_code_lookup
where is_active = 'Y'
order by status_type, status_code
]',
           'Y' );

INSERT INTO semantic_example_question (
    question_text,
    preferred_object_name,
    exemplar_sql,
    is_enabled
) VALUES ( 'List addresses in a city',
           'V_ADDRESS_MASTER',
           q'[
select
    address_line1,
    city,
    state_province,
    postal_code,
    country_code
from v_address_master
where city = :city
order by address_line1
]',
           'Y' );

COMMIT;
