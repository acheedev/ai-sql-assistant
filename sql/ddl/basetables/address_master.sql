DROP TABLE address_master CASCADE CONSTRAINTS;

CREATE TABLE address_master (
    address_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    address_line1  VARCHAR2(200),
    address_line2  VARCHAR2(200),
    city           VARCHAR2(100),
    state_province VARCHAR2(100),
    postal_code    VARCHAR2(20),
    country_code   VARCHAR2(10),
    created_on     TIMESTAMP DEFAULT current_timestamp
);
