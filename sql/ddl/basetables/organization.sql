DROP TABLE organization CASCADE CONSTRAINTS;

CREATE TABLE organization (
    organization_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    organization_code  VARCHAR2(30) NOT NULL,
    organization_name  VARCHAR2(200) NOT NULL,
    organization_type  VARCHAR2(50),
    status_code        VARCHAR2(30) NOT NULL,
    primary_address_id NUMBER,
    created_on         TIMESTAMP DEFAULT current_timestamp NOT NULL,
    CONSTRAINT organization_uk1 UNIQUE ( organization_code ),
    CONSTRAINT organization_fk1 FOREIGN KEY ( status_code )
        REFERENCES status_code_lookup ( status_code ),
    CONSTRAINT organization_fk2 FOREIGN KEY ( primary_address_id )
        REFERENCES address_master ( address_id )
);
