-- Create admin procedures
@@ddl/procedures/p$admin_drop_table.sql
@@ddl/procedures/p$admin_drop_all_basetables.sql
@@ddl/procedures/p$admin_drop_all_semtables.sql

-- Drop all basetables
@@drop_basetables.sql

-- Build each basetable
@@ddl/basetables/t_address_master.sql
@@ddl/basetables/t_customer_account.sql
@@ddl/basetables/t_inventory_balance.sql
@@ddl/basetables/t_invoice_header.sql
@@ddl/basetables/t_order_header.sql
@@ddl/basetables/t_order_line_item.sql
@@ddl/basetables/t_organization.sql
@@ddl/basetables/t_payment_transaction.sql
@@ddl/basetables/t_product_master.sql
@@ddl/basetables/t_product_sku.sql
@@ddl/basetables/t_shipment_header.sql
@@ddl/basetables/t_status_code_lookup.sql

-- Drop all semtables
@@drop_semtables.sql

-- Build each semtable
@@ddl/semantic/t_semantic_object.sql
@@ddl/semantic/t_semantic_column.sql
@@ddl/semantic/t_semantic_example_question.sql
@@ddl/semantic/t_semantic_object_alias.sql

-- Rebuild each view
@@ddl/views/v_address_master.sql
@@ddl/views/v_customer_account.sql
@@ddl/views/v_customer_order_summary.sql
@@ddl/views/v_inventory_balance.sql
@@ddl/views/v_inventory_status.sql
@@ddl/views/v_invoice_header.sql
@@ddl/views/v_order_detail.sql
@@ddl/views/v_order_header.sql
@@ddl/views/v_order_line_item.sql
@@ddl/views/v_organization.sql
@@ddl/views/v_payment_transaction.sql
@@ddl/views/v_product_master.sql
@@ddl/views/v_product_sku.sql
@@ddl/views/v_shipment_header.sql
@@ddl/views/v_status_code_lookup.sql
