CREATE TABLE semantic_object (
    object_name       VARCHAR2(128) PRIMARY KEY,
    object_type       VARCHAR2(30) NOT NULL,
    business_name     VARCHAR2(200) NOT NULL,
    short_description VARCHAR2(1000),
    include_in_ai     VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    preferred_for_ai  VARCHAR2(1) DEFAULT 'N' NOT NULL,
    default_rank      NUMBER DEFAULT 100 NOT NULL,
    status            VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,
    created_on        TIMESTAMP DEFAULT current_timestamp NOT NULL,
    CONSTRAINT semantic_object_chk1 CHECK ( include_in_ai IN ( 'Y',
                                                               'N' ) ),
    CONSTRAINT semantic_object_chk2 CHECK ( preferred_for_ai IN ( 'Y',
                                                                  'N' ) ),
    CONSTRAINT semantic_object_chk3
        CHECK ( object_type IN ( 'TABLE',
                                 'VIEW',
                                 'BUSINESS_VIEW' ) ),
    CONSTRAINT semantic_object_chk4 CHECK ( status IN ( 'ACTIVE',
                                                        'INACTIVE' ) )
);
