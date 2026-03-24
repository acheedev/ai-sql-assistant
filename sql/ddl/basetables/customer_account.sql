DROP TABLE customer_account CASCADE CONSTRAINTS;

CREATE TABLE customer_account (
    customer_account_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_account_number VARCHAR2(30) NOT NULL,
    organization_id         NUMBER NOT NULL,
    customer_name           VARCHAR2(200) NOT NULL,
    customer_type           VARCHAR2(50),
    status_code             VARCHAR2(30) NOT NULL,
    billing_address_id      NUMBER,
    shipping_address_id     NUMBER,
    created_on              TIMESTAMP DEFAULT current_timestamp NOT NULL,
    CONSTRAINT customer_account_uk1 UNIQUE ( customer_account_number ),
    CONSTRAINT customer_account_fk1 FOREIGN KEY ( organization_id )
        REFERENCES organization ( organization_id ),
    CONSTRAINT customer_account_fk2 FOREIGN KEY ( status_code )
        REFERENCES status_code_lookup ( status_code ),
    CONSTRAINT customer_account_fk3 FOREIGN KEY ( billing_address_id )
        REFERENCES address_master ( address_id ),
    CONSTRAINT customer_account_fk4 FOREIGN KEY ( shipping_address_id )
        REFERENCES address_master ( address_id )
);
