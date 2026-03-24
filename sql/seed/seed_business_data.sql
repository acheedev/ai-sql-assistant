pro    =========================================================
pro    Seeding business data
pro    =========================================================

-- -------------------------------------------------------------
-- organization
-- -------------------------------------------------------------
INSERT INTO organization (
    organization_code,
    organization_name,
    organization_type,
    status_code,
    primary_address_id
) VALUES ( 'ORG100',
           'Acme Manufacturing',
           'CUSTOMER',
           'ACTIVE',
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '100 Market Street'
                  AND city = 'Charlotte'
           ) );

INSERT INTO organization (
    organization_code,
    organization_name,
    organization_type,
    status_code,
    primary_address_id
) VALUES ( 'ORG200',
           'Blue Horizon Retail',
           'CUSTOMER',
           'ACTIVE',
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '500 Lake Drive'
                  AND city = 'Cornelius'
           ) );

INSERT INTO organization (
    organization_code,
    organization_name,
    organization_type,
    status_code,
    primary_address_id
) VALUES ( 'ORG300',
           'Northwind Logistics',
           'PARTNER',
           'PENDING',
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '12 Industrial Park Road'
                  AND city = 'Raleigh'
           ) );

INSERT INTO organization (
    organization_code,
    organization_name,
    organization_type,
    status_code,
    primary_address_id
) VALUES ( 'ORG400',
           'Summit Health Group',
           'CUSTOMER',
           'ACTIVE',
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '88 Innovation Way'
                  AND city = 'Austin'
           ) );

INSERT INTO organization (
    organization_code,
    organization_name,
    organization_type,
    status_code,
    primary_address_id
) VALUES ( 'ORG500',
           'Legacy Services',
           'CUSTOMER',
           'INACTIVE',
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '200 King Street West'
                  AND city = 'Toronto'
           ) );

-- -------------------------------------------------------------
-- customer_account
-- -------------------------------------------------------------
INSERT INTO customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST1001',
           (
               SELECT organization_id
                 FROM organization
                WHERE organization_code = 'ORG100'
           ),
           'Acme East Division',
           'B2B',
           'ACTIVE',
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '100 Market Street'
                  AND city = 'Charlotte'
           ),
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '250 Trade Avenue'
                  AND city = 'Charlotte'
           ) );

INSERT INTO customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST1002',
           (
               SELECT organization_id
                 FROM organization
                WHERE organization_code = 'ORG100'
           ),
           'Acme West Division',
           'B2B',
           'ACTIVE',
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '100 Market Street'
                  AND city = 'Charlotte'
           ),
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '15 Harbor Boulevard'
                  AND city = 'San Diego'
           ) );

INSERT INTO customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST2001',
           (
               SELECT organization_id
                 FROM organization
                WHERE organization_code = 'ORG200'
           ),
           'Blue Horizon Stores',
           'RETAIL',
           'ACTIVE',
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '500 Lake Drive'
                  AND city = 'Cornelius'
           ),
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '742 Evergreen Terrace'
                  AND city = 'Denver'
           ) );

INSERT INTO customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST2002',
           (
               SELECT organization_id
                 FROM organization
                WHERE organization_code = 'ORG200'
           ),
           'Blue Horizon Online',
           'ECOMMERCE',
           'PENDING',
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '500 Lake Drive'
                  AND city = 'Cornelius'
           ),
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '500 Lake Drive'
                  AND city = 'Cornelius'
           ) );

INSERT INTO customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST3001',
           (
               SELECT organization_id
                 FROM organization
                WHERE organization_code = 'ORG300'
           ),
           'Northwind Freight',
           'LOGISTICS',
           'PENDING',
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '12 Industrial Park Road'
                  AND city = 'Raleigh'
           ),
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '12 Industrial Park Road'
                  AND city = 'Raleigh'
           ) );

INSERT INTO customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST4001',
           (
               SELECT organization_id
                 FROM organization
                WHERE organization_code = 'ORG400'
           ),
           'Summit Primary Care',
           'HEALTHCARE',
           'ACTIVE',
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '88 Innovation Way'
                  AND city = 'Austin'
           ),
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '88 Innovation Way'
                  AND city = 'Austin'
           ) );

INSERT INTO customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST4002',
           (
               SELECT organization_id
                 FROM organization
                WHERE organization_code = 'ORG400'
           ),
           'Summit Specialty Clinic',
           'HEALTHCARE',
           'SUSPENDED',
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '88 Innovation Way'
                  AND city = 'Austin'
           ),
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '15 Harbor Boulevard'
                  AND city = 'San Diego'
           ) );

INSERT INTO customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST5001',
           (
               SELECT organization_id
                 FROM organization
                WHERE organization_code = 'ORG500'
           ),
           'Legacy Public Sector',
           'GOVERNMENT',
           'INACTIVE',
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '200 King Street West'
                  AND city = 'Toronto'
           ),
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '200 King Street West'
                  AND city = 'Toronto'
           ) );

INSERT INTO customer_account (
    customer_account_number,
    organization_id,
    customer_name,
    customer_type,
    status_code,
    billing_address_id,
    shipping_address_id
) VALUES ( 'CUST5002',
           (
               SELECT organization_id
                 FROM organization
                WHERE organization_code = 'ORG500'
           ),
           'Legacy Enterprise',
           'B2B',
           'CLOSED',
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '200 King Street West'
                  AND city = 'Toronto'
           ),
           (
               SELECT address_id
                 FROM address_master
                WHERE address_line1 = '100 Market Street'
                  AND city = 'Charlotte'
           ) );

COMMIT;
