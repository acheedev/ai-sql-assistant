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
