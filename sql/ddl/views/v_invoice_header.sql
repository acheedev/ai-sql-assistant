CREATE OR REPLACE VIEW v_invoice_header AS
    SELECT ih.invoice_id,
           ih.invoice_number,
           ih.order_id,
           ih.customer_account_id,
           ih.invoice_date,
           ih.due_date,
           ih.status_code,
           ih.invoice_total_amount,
           ih.created_on
      FROM invoice_header ih;
