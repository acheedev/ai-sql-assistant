CREATE TABLE t_semantic_example_question (
    example_question_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    question_text         VARCHAR2(1000) NOT NULL,
    preferred_object_name VARCHAR2(128) NOT NULL,
    exemplar_sql          CLOB,
    is_enabled            VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    created_on            TIMESTAMP DEFAULT current_timestamp NOT NULL,
    CONSTRAINT t_semantic_example_q_fk1 FOREIGN KEY ( preferred_object_name )
        REFERENCES t_semantic_object ( object_name ),
    CONSTRAINT t_semantic_example_q_chk1 CHECK ( is_enabled IN ( 'Y',
                                                                 'N' ) )
);
