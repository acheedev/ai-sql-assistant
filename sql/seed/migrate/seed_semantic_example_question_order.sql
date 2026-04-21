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
