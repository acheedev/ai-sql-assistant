CREATE TABLE t_order_line_item (
    order_line_item_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id           NUMBER NOT NULL,
    line_number        NUMBER NOT NULL,
    product_sku_id     NUMBER NOT NULL,
    quantity           NUMBER(10) NOT NULL,
    unit_price         NUMBER(12,2) NOT NULL,
    line_total         NUMBER(12,2) NOT NULL,
    status_code        VARCHAR2(30) NOT NULL,
    created_on         TIMESTAMP DEFAULT current_timestamp NOT NULL,
    CONSTRAINT t_order_line_item_uk1 UNIQUE ( order_id,
                                              line_number ),
    CONSTRAINT t_order_line_item_chk1 CHECK ( quantity > 0 ),
    CONSTRAINT t_order_line_item_chk2 CHECK ( unit_price >= 0 ),
    CONSTRAINT t_order_line_item_chk3 CHECK ( line_total >= 0 ),
    CONSTRAINT t_order_line_item_fk1 FOREIGN KEY ( order_id )
        REFERENCES t_order_header ( order_id ),
    CONSTRAINT t_order_line_item_fk2 FOREIGN KEY ( product_sku_id )
        REFERENCES t_product_sku ( product_sku_id ),
    CONSTRAINT t_order_line_item_fk3 FOREIGN KEY ( status_code )
        REFERENCES t_status_code_lookup ( status_code )
);
