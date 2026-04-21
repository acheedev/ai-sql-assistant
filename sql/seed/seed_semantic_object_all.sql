INSERT INTO t_semantic_object (
    object_name,
    object_type,
    business_name,
    short_description,
    include_in_ai,
    preferred_for_ai,
    default_rank,
    status
) VALUES ( 'V_SHIPMENT_HEADER',
           'VIEW',
           'Shipment',
           'Shipment records tied to orders, including shipment date, destination address, and shipment amount.',
           'Y',
           'Y',
           20,
           'ACTIVE' );

INSERT INTO t_semantic_object (
    object_name,
    object_type,
    business_name,
    short_description,
    include_in_ai,
    preferred_for_ai,
    default_rank,
    status
) VALUES ( 'V_INVENTORY_BALANCE',
           'VIEW',
           'Inventory Balance',
           'Current inventory by SKU and location, including quantity on hand and reorder threshold.',
           'Y',
           'Y',
           22,
           'ACTIVE' );
COMMIT;

INSERT INTO t_semantic_object (
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

INSERT INTO t_semantic_object (
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

COMMIT;

INSERT INTO t_semantic_object (
    object_name,
    object_type,
    business_name,
    short_description,
    include_in_ai,
    preferred_for_ai,
    default_rank,
    status
) VALUES ( 'V_PRODUCT_MASTER',
           'VIEW',
           'Product',
           'Business product master records used to group related SKUs.',
           'Y',
           'Y',
           30,
           'ACTIVE' );

INSERT INTO t_semantic_object (
    object_name,
    object_type,
    business_name,
    short_description,
    include_in_ai,
    preferred_for_ai,
    default_rank,
    status
) VALUES ( 'V_PRODUCT_SKU',
           'VIEW',
           'Product SKU',
           'Sellable product SKU records including unit price and product linkage.',
           'Y',
           'Y',
           25,
           'ACTIVE' );

COMMIT;

INSERT INTO t_semantic_object (
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
           'Line-item level view. One row per order line. Use when SKU, product, quantity, or pricing detail is needed. For order-level queries without line detail, prefer V_ORDER_HEADER or V_CUSTOMER_ORDER_SUMMARY.',
           'Y',
           'Y',
           12,
           'ACTIVE' );

INSERT INTO t_semantic_object (
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

INSERT INTO t_semantic_object (
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

INSERT INTO t_semantic_object (
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

INSERT INTO t_semantic_object (
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

COMMIT;

INSERT INTO t_semantic_object (
    object_name,
    object_type,
    business_name,
    short_description,
    include_in_ai,
    preferred_for_ai,
    default_rank,
    status
) VALUES ( 'V_CUSTOMER_ACCOUNT',
           'VIEW',
           'Customer Account',
           'Primary customer account entity for account-level customer queries.',
           'Y',
           'Y',
           10,
           'ACTIVE' );

INSERT INTO t_semantic_object (
    object_name,
    object_type,
    business_name,
    short_description,
    include_in_ai,
    preferred_for_ai,
    default_rank,
    status
) VALUES ( 'V_ORGANIZATION',
           'VIEW',
           'Organization',
           'Business organization or company associated with customer accounts.',
           'Y',
           'Y',
           20,
           'ACTIVE' );

INSERT INTO t_semantic_object (
    object_name,
    object_type,
    business_name,
    short_description,
    include_in_ai,
    preferred_for_ai,
    default_rank,
    status
) VALUES ( 'V_ADDRESS_MASTER',
           'VIEW',
           'Address',
           'Reference address data used by organizations and customer accounts.',
           'Y',
           'N',
           40,
           'ACTIVE' );

INSERT INTO t_semantic_object (
    object_name,
    object_type,
    business_name,
    short_description,
    include_in_ai,
    preferred_for_ai,
    default_rank,
    status
) VALUES ( 'V_STATUS_CODE_LOOKUP',
           'VIEW',
           'Status Code',
           'Lookup of status codes and status descriptions.',
           'Y',
           'N',
           50,
           'ACTIVE' );

COMMIT;
