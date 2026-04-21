INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ACCOUNT',
           'CUSTOMER_ACCOUNT_ID',
           'Customer Account ID',
           'N',
           'Y',
           'N',
           'Y',
           90 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ACCOUNT',
           'CUSTOMER_ACCOUNT_NUMBER',
           'Customer Account Number',
           'Y',
           'Y',
           'Y',
           'Y',
           10 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ACCOUNT',
           'CUSTOMER_NAME',
           'Customer Name',
           'Y',
           'N',
           'Y',
           'Y',
           20 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ACCOUNT',
           'CUSTOMER_TYPE',
           'Customer Type',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ACCOUNT',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_CUSTOMER_ACCOUNT',
           'ORGANIZATION_ID',
           'Organization ID',
           'N',
           'N',
           'N',
           'Y',
           50 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORGANIZATION',
           'ORGANIZATION_ID',
           'Organization ID',
           'N',
           'Y',
           'N',
           'Y',
           90 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORGANIZATION',
           'ORGANIZATION_CODE',
           'Organization Code',
           'Y',
           'Y',
           'Y',
           'Y',
           10 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORGANIZATION',
           'ORGANIZATION_NAME',
           'Organization Name',
           'Y',
           'N',
           'Y',
           'Y',
           20 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORGANIZATION',
           'ORGANIZATION_TYPE',
           'Organization Type',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ORGANIZATION',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'N',
           'Y',
           'Y',
           40 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ADDRESS_MASTER',
           'ADDRESS_ID',
           'Address ID',
           'N',
           'Y',
           'N',
           'Y',
           90 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ADDRESS_MASTER',
           'ADDRESS_LINE1',
           'Address Line 1',
           'Y',
           'N',
           'Y',
           'Y',
           10 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ADDRESS_MASTER',
           'CITY',
           'City',
           'Y',
           'N',
           'Y',
           'Y',
           20 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ADDRESS_MASTER',
           'STATE_PROVINCE',
           'State / Province',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ADDRESS_MASTER',
           'POSTAL_CODE',
           'Postal Code',
           'Y',
           'N',
           'N',
           'Y',
           40 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_ADDRESS_MASTER',
           'COUNTRY_CODE',
           'Country Code',
           'Y',
           'N',
           'N',
           'Y',
           50 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_STATUS_CODE_LOOKUP',
           'STATUS_CODE',
           'Status Code',
           'Y',
           'Y',
           'Y',
           'Y',
           10 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_STATUS_CODE_LOOKUP',
           'STATUS_TYPE',
           'Status Type',
           'Y',
           'N',
           'Y',
           'Y',
           20 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_STATUS_CODE_LOOKUP',
           'STATUS_DESCRIPTION',
           'Status Description',
           'Y',
           'N',
           'Y',
           'Y',
           30 );

INSERT INTO semantic_column (
    object_name,
    column_name,
    business_name,
    is_human_readable,
    is_identifier,
    is_default_select,
    is_filterable,
    display_rank
) VALUES ( 'V_STATUS_CODE_LOOKUP',
           'IS_ACTIVE',
           'Is Active',
           'Y',
           'N',
           'N',
           'Y',
           40 );
