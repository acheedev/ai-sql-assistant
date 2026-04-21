INSERT INTO semantic_object (
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

INSERT INTO semantic_object (
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

INSERT INTO semantic_object (
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

INSERT INTO semantic_object (
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
