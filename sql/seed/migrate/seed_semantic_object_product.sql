INSERT INTO semantic_object (
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

INSERT INTO semantic_object (
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
