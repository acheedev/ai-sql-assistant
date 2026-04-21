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
