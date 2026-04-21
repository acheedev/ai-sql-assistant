CREATE TABLE t_order_header (
    order_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_number        VARCHAR2(30) NOT NULL,
    customer_account_id NUMBER NOT NULL,
    order_date          DATE NOT NULL,
    status_code         VARCHAR2(30) NOT NULL,
    order_total_amount  NUMBER(12,2) NOT NULL,
    created_on          TIMESTAMP DEFAULT current_timestamp NOT NULL,
    CONSTRAINT t_order_header_uk1 UNIQUE ( order_number ),
    CONSTRAINT t_order_header_chk1 CHECK ( order_total_amount >= 0 ),
    CONSTRAINT t_order_header_fk1 FOREIGN KEY ( customer_account_id )
        REFERENCES t_customer_account ( customer_account_id ),
    CONSTRAINT t_order_header_fk2 FOREIGN KEY ( status_code )
        REFERENCES t_status_code_lookup ( status_code )
);
