CREATE TABLE t_invoice_header (
    invoice_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    invoice_number       VARCHAR2(30) NOT NULL,
    order_id             NUMBER NOT NULL,
    customer_account_id  NUMBER NOT NULL,
    invoice_date         DATE NOT NULL,
    due_date             DATE,
    status_code          VARCHAR2(30) NOT NULL,
    invoice_total_amount NUMBER(12,2) NOT NULL,
    created_on           TIMESTAMP DEFAULT current_timestamp NOT NULL,
    CONSTRAINT t_invoice_header_uk1 UNIQUE ( invoice_number ),
    CONSTRAINT t_invoice_header_chk1 CHECK ( invoice_total_amount >= 0 ),
    CONSTRAINT t_invoice_header_fk1 FOREIGN KEY ( order_id )
        REFERENCES t_order_header ( order_id ),
    CONSTRAINT t_invoice_header_fk2 FOREIGN KEY ( customer_account_id )
        REFERENCES t_customer_account ( customer_account_id ),
    CONSTRAINT t_invoice_header_fk3 FOREIGN KEY ( status_code )
        REFERENCES t_status_code_lookup ( status_code )
);
