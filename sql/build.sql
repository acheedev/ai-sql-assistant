@@ddl/basetables/address_master.sql
@@ddl/basetables/status_code_lookup.sql
@@ddl/basetables/organization.sql
@@ddl/basetables/customer_account.sql
@@ddl/basetables/product_master.sql
@@ddl/basetables/product_sku.sql
@@ddl/basetables/order_header.sql
@@ddl/basetables/order_line_item.sql
@@ddl/basetables/shipment_header.sql
@@ddl/basetables/inventory_balance.sql
--
@@ddl/views/v_address_master.sql
@@ddl/views/v_customer_account.sql
@@ddl/views/v_organization.sql
@@ddl/views/v_status_code_lookup.sql
@@ddl/views/v_product_master.sql
@@ddl/views/v_product_sku.sql
@@ddl/views/v_order_header.sql
@@ddl/views/v_order_line_item.sql
@@ddl/views/v_shipment_header.sql
@@ddl/views/v_inventory_balance.sql
--
@@ddl/semantic/semantic_object.sql
@@ddl/semantic/semantic_object_alias.sql
@@ddl/semantic/semantic_column.sql
@@ddl/semantic/semantic_example_question.sql
--
@@seed/seed_reference_data.sql
@@seed/seed_business_data.sql
@@seed/seed_product_data.sql
@@seed/seed_order_data.sql
--
@@seed/seed_semantic_object.sql
@@seed/seed_semantic_object_alias.sql
@@seed/seed_semantic_column.sql
@@seed/seed_semantic_example_question.sql
--
@@seed/seed_semantic_object_product.sql
@@seed/seed_semantic_object_alias_product.sql
@@seed/seed_semantic_column_product.sql
@@seed/seed_semantic_example_question_product.sql


--

--



--


pro    =========================================================
pro    Reference data counts
pro    =========================================================

SELECT 'STATUS_CODE_LOOKUP' AS table_name,
       COUNT(*) AS row_count
  FROM status_code_lookup
UNION ALL
SELECT 'ADDRESS_MASTER',
       COUNT(*)
  FROM address_master;

pro    =========================================================
pro    Business data counts
pro    =========================================================

SELECT 'ORGANIZATION' AS table_name,
       COUNT(*) AS row_count
  FROM organization
UNION ALL
SELECT 'CUSTOMER_ACCOUNT',
       COUNT(*)
  FROM customer_account;


COMMIT;
