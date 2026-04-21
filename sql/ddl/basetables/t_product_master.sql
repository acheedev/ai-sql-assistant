CREATE TABLE t_product_master (
    product_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_code        VARCHAR2(30) NOT NULL,
    product_name        VARCHAR2(200) NOT NULL,
    product_description VARCHAR2(1000),
    product_category    VARCHAR2(50),
    status_code         VARCHAR2(30) NOT NULL,
    created_on          TIMESTAMP DEFAULT current_timestamp NOT NULL,
    CONSTRAINT t_product_master_uk1 UNIQUE ( product_code ),
    CONSTRAINT t_product_master_fk1 FOREIGN KEY ( status_code )
        REFERENCES t_status_code_lookup ( status_code )
);
