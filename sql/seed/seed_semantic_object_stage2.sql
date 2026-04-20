INSERT INTO semantic_object (
    object_name,
    object_type,
    business_name,
    short_description,
    include_in_ai,
    preferred_for_ai,
    default_rank,
    status
) VALUES ( 'V_ORDER_DETAIL',
           'VIEW',
           'Order Detail',
           'Denormalized order detail view joining order, customer, organization, line item, SKU, and product.',
           'Y',
           'Y',
           12,
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
) VALUES ( 'V_CUSTOMER_ORDER_SUMMARY',
           'VIEW',
           'Customer Order Summary',
           'Customer-level order summary including order counts, total order amount, and first/most recent order dates.',
           'Y',
           'Y',
           14,
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
) VALUES ( 'V_INVENTORY_STATUS',
           'VIEW',
           'Inventory Status',
           'Inventory status by SKU and product, including location, quantities, thresholds, and computed inventory health.',
           'Y',
           'Y',
           16,
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
) VALUES ( 'V_INVOICE_HEADER',
           'VIEW',
           'Invoice',
           'Invoice records including order, customer, invoice dates, status, and invoice total amount.',
           'Y',
           'Y',
           17,
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
) VALUES ( 'V_PAYMENT_TRANSACTION',
           'VIEW',
           'Payment Transaction',
           'Payment records tied to invoices, including payment date, method, status, and payment amount.',
           'Y',
           'Y',
           19,
           'ACTIVE' );
