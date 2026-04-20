CREATE OR REPLACE VIEW v_payment_transaction AS
    SELECT pt.payment_transaction_id,
           pt.payment_reference,
           pt.invoice_id,
           pt.payment_date,
           pt.payment_method,
           pt.status_code,
           pt.payment_amount,
           pt.created_on
      FROM payment_transaction pt;
