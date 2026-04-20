INSERT INTO semantic_object (
    object_name,
    object_type,
    business_name,
    short_description,
    include_in_ai,
    preferred_for_ai,
    default_rank,
    status
) VALUES ( 'V_ORDER_HEADER',
           'VIEW',
           'Order',
           'Order header records including customer, order date, status, and total amount.',
           'Y',
           'Y',
           15,
           'ACTIVE' );

INSERT INTO semantic_object (
    object_name,
    object_type,
    business_name,
    short_description,
    include_in_ai,
    preferred_for_ai,
    default_rank,
    status
) VALUES ( 'V_ORDER_LINE_ITEM',
           'VIEW',
           'Order Line Item',
           'Order line item records including SKU, quantity, unit price, and line total.',
           'Y',
           'Y',
           18,
           'ACTIVE' );
