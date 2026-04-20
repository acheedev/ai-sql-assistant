INSERT INTO semantic_object (
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

INSERT INTO semantic_object (
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
