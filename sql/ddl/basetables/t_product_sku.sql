CREATE TABLE t_product_sku (
    product_sku_id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id      NUMBER NOT NULL,
    sku_code        VARCHAR2(30) NOT NULL,
    sku_name        VARCHAR2(200) NOT NULL,
    sku_description VARCHAR2(1000),
    unit_price      NUMBER(12,2) NOT NULL,
    status_code     VARCHAR2(30) NOT NULL,
    created_on      TIMESTAMP DEFAULT current_timestamp NOT NULL,
    CONSTRAINT t_product_sku_uk1 UNIQUE ( sku_code ),
    CONSTRAINT t_product_sku_chk1 CHECK ( unit_price >= 0 ),
    CONSTRAINT t_product_sku_fk1 FOREIGN KEY ( product_id )
        REFERENCES t_product_master ( product_id ),
    CONSTRAINT t_product_sku_fk2 FOREIGN KEY ( status_code )
        REFERENCES t_status_code_lookup ( status_code )
);
