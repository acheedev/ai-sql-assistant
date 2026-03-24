CREATE TABLE semantic_column (
    object_name       VARCHAR2(128) NOT NULL,
    column_name       VARCHAR2(128) NOT NULL,
    business_name     VARCHAR2(200),
    is_human_readable VARCHAR2(1) DEFAULT 'N' NOT NULL,
    is_identifier     VARCHAR2(1) DEFAULT 'N' NOT NULL,
    is_default_select VARCHAR2(1) DEFAULT 'N' NOT NULL,
    is_filterable     VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    display_rank      NUMBER DEFAULT 100 NOT NULL,
    created_on        TIMESTAMP DEFAULT current_timestamp NOT NULL,
    CONSTRAINT semantic_column_pk PRIMARY KEY ( object_name,
                                                column_name ),
    CONSTRAINT semantic_column_fk1 FOREIGN KEY ( object_name )
        REFERENCES semantic_object ( object_name )
            ON DELETE CASCADE,
    CONSTRAINT semantic_column_chk1 CHECK ( is_human_readable IN ( 'Y',
                                                                   'N' ) ),
    CONSTRAINT semantic_column_chk2 CHECK ( is_identifier IN ( 'Y',
                                                               'N' ) ),
    CONSTRAINT semantic_column_chk3 CHECK ( is_default_select IN ( 'Y',
                                                                   'N' ) ),
    CONSTRAINT semantic_column_chk4 CHECK ( is_filterable IN ( 'Y',
                                                               'N' ) )
);
