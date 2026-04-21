CREATE TABLE t_shipment_header (
    shipment_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    shipment_number       VARCHAR2(30) NOT NULL,
    order_id              NUMBER NOT NULL,
    shipment_date         DATE NOT NULL,
    status_code           VARCHAR2(30) NOT NULL,
    ship_to_address_id    NUMBER,
    shipment_total_amount NUMBER(12,2) NOT NULL,
    created_on            TIMESTAMP DEFAULT current_timestamp NOT NULL,
    CONSTRAINT t_shipment_header_uk1 UNIQUE ( shipment_number ),
    CONSTRAINT t_shipment_header_chk1 CHECK ( shipment_total_amount >= 0 ),
    CONSTRAINT t_shipment_header_fk1 FOREIGN KEY ( order_id )
        REFERENCES t_order_header ( order_id ),
    CONSTRAINT t_shipment_header_fk2 FOREIGN KEY ( status_code )
        REFERENCES t_status_code_lookup ( status_code ),
    CONSTRAINT t_shipment_header_fk3 FOREIGN KEY ( ship_to_address_id )
        REFERENCES t_address_master ( address_id )
);
