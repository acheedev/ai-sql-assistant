pro =========================================================
pro    Seeding reference data
pro    =========================================================

-- -------------------------------------------------------------
-- status_code_lookup
-- -------------------------------------------------------------
INSERT INTO status_code_lookup (
    status_code,
    status_type,
    status_description,
    is_active
) VALUES ( 'ACTIVE',
           'GENERAL',
           'Active / currently in use',
           'Y' );

INSERT INTO status_code_lookup (
    status_code,
    status_type,
    status_description,
    is_active
) VALUES ( 'INACTIVE',
           'GENERAL',
           'Inactive / no longer in use',
           'Y' );

INSERT INTO status_code_lookup (
    status_code,
    status_type,
    status_description,
    is_active
) VALUES ( 'PENDING',
           'GENERAL',
           'Pending review or activation',
           'Y' );

INSERT INTO status_code_lookup (
    status_code,
    status_type,
    status_description,
    is_active
) VALUES ( 'SUSPENDED',
           'GENERAL',
           'Temporarily suspended',
           'Y' );

INSERT INTO status_code_lookup (
    status_code,
    status_type,
    status_description,
    is_active
) VALUES ( 'CLOSED',
           'GENERAL',
           'Closed / terminated',
           'Y' );

INSERT INTO status_code_lookup (
    status_code,
    status_type,
    status_description,
    is_active
) VALUES ( 'ARCHIVED',
           'GENERAL',
           'Archived for history only',
           'N' );

-- -------------------------------------------------------------
-- address_master
-- -------------------------------------------------------------
INSERT INTO address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '100 Market Street',
           'Suite 300',
           'Charlotte',
           'NC',
           '28202',
           'US' );

INSERT INTO address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '250 Trade Avenue',
           NULL,
           'Charlotte',
           'NC',
           '28203',
           'US' );

INSERT INTO address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '500 Lake Drive',
           NULL,
           'Cornelius',
           'NC',
           '28031',
           'US' );

INSERT INTO address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '742 Evergreen Terrace',
           NULL,
           'Denver',
           'NC',
           '28037',
           'US' );

INSERT INTO address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '12 Industrial Park Road',
           'Building B',
           'Raleigh',
           'NC',
           '27601',
           'US' );

INSERT INTO address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '88 Innovation Way',
           NULL,
           'Austin',
           'TX',
           '73301',
           'US' );

INSERT INTO address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '15 Harbor Boulevard',
           'Floor 5',
           'San Diego',
           'CA',
           '92101',
           'US' );

INSERT INTO address_master (
    address_line1,
    address_line2,
    city,
    state_province,
    postal_code,
    country_code
) VALUES ( '200 King Street West',
           'Suite 1900',
           'Toronto',
           'ON',
           'M5H 3T4',
           'CA' );

COMMIT;
