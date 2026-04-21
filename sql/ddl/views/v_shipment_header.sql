CREATE OR REPLACE VIEW v_shipment_header AS
    SELECT sh.shipment_id,
           sh.shipment_number,
           sh.order_id,
           sh.shipment_date,
           sh.status_code,
           sh.ship_to_address_id,
           sh.shipment_total_amount,
           sh.created_on
      FROM t_shipment_header sh;
