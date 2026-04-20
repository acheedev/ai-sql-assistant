CREATE TABLE inventory_balance (
    inventory_balance_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_sku_id       NUMBER NOT NULL,
    location_code        VARCHAR2(30) NOT NULL,
    quantity_on_hand     NUMBER(12) NOT NULL,
    reorder_threshold    NUMBER(12) NOT NULL,
    status_code          VARCHAR2(30) NOT NULL,
    created_on           TIMESTAMP DEFAULT current_timestamp NOT NULL,
    CONSTRAINT inventory_balance_uk1 UNIQUE ( product_sku_id,
                                              location_code ),
    CONSTRAINT inventory_balance_chk1 CHECK ( quantity_on_hand >= 0 ),
    CONSTRAINT inventory_balance_chk2 CHECK ( reorder_threshold >= 0 ),
    CONSTRAINT inventory_balance_fk1 FOREIGN KEY ( product_sku_id )
        REFERENCES product_sku ( product_sku_id ),
    CONSTRAINT inventory_balance_fk2 FOREIGN KEY ( status_code )
        REFERENCES status_code_lookup ( status_code )
);
