CREATE TABLE payment_transaction (
    payment_transaction_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    payment_reference      VARCHAR2(30) NOT NULL,
    invoice_id             NUMBER NOT NULL,
    payment_date           DATE NOT NULL,
    payment_method         VARCHAR2(30),
    status_code            VARCHAR2(30) NOT NULL,
    payment_amount         NUMBER(12,2) NOT NULL,
    created_on             TIMESTAMP DEFAULT current_timestamp NOT NULL,
    CONSTRAINT payment_transaction_uk1 UNIQUE ( payment_reference ),
    CONSTRAINT payment_transaction_chk1 CHECK ( payment_amount >= 0 ),
    CONSTRAINT payment_transaction_fk1 FOREIGN KEY ( invoice_id )
        REFERENCES invoice_header ( invoice_id ),
    CONSTRAINT payment_transaction_fk2 FOREIGN KEY ( status_code )
        REFERENCES status_code_lookup ( status_code )
);
