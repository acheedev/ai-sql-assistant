CREATE TABLE t_status_code_lookup (
    status_code        VARCHAR2(30) PRIMARY KEY,
    status_type        VARCHAR2(30) NOT NULL,
    status_description VARCHAR2(200),
    is_active          VARCHAR2(1) DEFAULT 'Y',
    created_on         TIMESTAMP DEFAULT current_timestamp,
    CONSTRAINT t_status_code_chk1 CHECK ( is_active IN ( 'Y',
                                                         'N' ) )
);
