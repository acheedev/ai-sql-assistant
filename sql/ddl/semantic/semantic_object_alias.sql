CREATE TABLE semantic_object_alias (
    object_name  VARCHAR2(128) NOT NULL,
    alias_term   VARCHAR2(200) NOT NULL,
    alias_weight NUMBER DEFAULT 10 NOT NULL,
    created_on   TIMESTAMP DEFAULT current_timestamp NOT NULL,
    CONSTRAINT semantic_object_alias_pk PRIMARY KEY ( object_name,
                                                      alias_term ),
    CONSTRAINT semantic_object_alias_fk1 FOREIGN KEY ( object_name )
        REFERENCES semantic_object ( object_name )
            ON DELETE CASCADE
);
