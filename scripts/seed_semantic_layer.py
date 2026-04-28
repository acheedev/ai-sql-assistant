"""
Seed (or re-seed) the AI SQL Assistant semantic layer tables.

Usage:
    python scripts/seed_semantic_layer.py           # upsert, idempotent
    python scripts/seed_semantic_layer.py --dry-run # print SQL, no DB touch
    python scripts/seed_semantic_layer.py --reset   # truncate + re-seed
"""

import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

# ---------------------------------------------------------------------------
# Seed data — extracted from live semantic layer tables
# All flag fields use "Y"/"N" strings (not booleans) — format_schema() checks == "Y"
# ---------------------------------------------------------------------------

OBJECTS = [
    {"object_name": "V_CUSTOMER_ACCOUNT",     "object_type": "VIEW", "business_name": "Customer Account",         "short_description": "Primary customer account entity for account-level customer queries.",                                                                                                                                                                   "include_in_ai": "Y", "preferred_for_ai": "Y", "status": "ACTIVE", "default_rank": 10},
    {"object_name": "V_ORDER_DETAIL",          "object_type": "VIEW", "business_name": "Order Detail",             "short_description": "Line-item level view. One row per order line. Use when SKU, product, quantity, or pricing detail is needed. For order-level queries without line detail, prefer V_ORDER_HEADER or V_CUSTOMER_ORDER_SUMMARY.",                        "include_in_ai": "Y", "preferred_for_ai": "Y", "status": "ACTIVE", "default_rank": 12},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY","object_type": "VIEW", "business_name": "Customer Order Summary",   "short_description": "Customer-level order summary including order counts, total order amount, and first/most recent order dates.",                                                                                                                        "include_in_ai": "Y", "preferred_for_ai": "Y", "status": "ACTIVE", "default_rank": 14},
    {"object_name": "V_ORDER_HEADER",          "object_type": "VIEW", "business_name": "Order",                    "short_description": "Order header records including customer, order date, status, and total amount. Status values: DRAFT, CONFIRMED, FULFILLED, CANCELLED, CLOSED.",                                                                                    "include_in_ai": "Y", "preferred_for_ai": "Y", "status": "ACTIVE", "default_rank": 15},
    {"object_name": "V_INVENTORY_STATUS",      "object_type": "VIEW", "business_name": "Inventory Status",         "short_description": "Inventory status by SKU and product, including location, quantities, thresholds, and computed inventory health.",                                                                                                                   "include_in_ai": "Y", "preferred_for_ai": "Y", "status": "ACTIVE", "default_rank": 16},
    {"object_name": "V_INVOICE_HEADER",        "object_type": "VIEW", "business_name": "Invoice",                  "short_description": "Invoice records tied to orders. Status values: ISSUED, PAID, OVERDUE, CANCELLED, VOID.",                                                                                                                                          "include_in_ai": "Y", "preferred_for_ai": "Y", "status": "ACTIVE", "default_rank": 17},
    {"object_name": "V_ORDER_LINE_ITEM",       "object_type": "VIEW", "business_name": "Order Line Item",          "short_description": "Order line item records including SKU, quantity, unit price, and line total.",                                                                                                                                                    "include_in_ai": "Y", "preferred_for_ai": "Y", "status": "ACTIVE", "default_rank": 18},
    {"object_name": "V_PAYMENT_TRANSACTION",   "object_type": "VIEW", "business_name": "Payment Transaction",      "short_description": "Payment records tied to invoices. Status values: PENDING, COMPLETED, FAILED, REFUNDED.",                                                                                                                                         "include_in_ai": "Y", "preferred_for_ai": "Y", "status": "ACTIVE", "default_rank": 19},
    {"object_name": "V_ORGANIZATION",          "object_type": "VIEW", "business_name": "Organization",             "short_description": "Business organization or company associated with customer accounts.",                                                                                                                                                             "include_in_ai": "Y", "preferred_for_ai": "Y", "status": "ACTIVE", "default_rank": 20},
    {"object_name": "V_SHIPMENT_HEADER",       "object_type": "VIEW", "business_name": "Shipment",                 "short_description": "Shipment records tied to orders. Status values: PENDING, IN_TRANSIT, DELIVERED, RETURNED, CANCELLED.",                                                                                                                           "include_in_ai": "Y", "preferred_for_ai": "Y", "status": "ACTIVE", "default_rank": 20},
    {"object_name": "V_INVENTORY_BALANCE",     "object_type": "VIEW", "business_name": "Inventory Balance",        "short_description": "Current inventory by SKU and location, including quantity on hand and reorder threshold.",                                                                                                                                       "include_in_ai": "Y", "preferred_for_ai": "Y", "status": "ACTIVE", "default_rank": 22},
    {"object_name": "V_PRODUCT_SKU",           "object_type": "VIEW", "business_name": "Product SKU",              "short_description": "Sellable product SKU records including unit price and product linkage.",                                                                                                                                                          "include_in_ai": "Y", "preferred_for_ai": "Y", "status": "ACTIVE", "default_rank": 25},
    {"object_name": "V_PRODUCT_MASTER",        "object_type": "VIEW", "business_name": "Product",                  "short_description": "Business product master records used to group related SKUs.",                                                                                                                                                                   "include_in_ai": "Y", "preferred_for_ai": "Y", "status": "ACTIVE", "default_rank": 30},
    {"object_name": "V_ADDRESS_MASTER",        "object_type": "VIEW", "business_name": "Address",                  "short_description": "Reference address data used by organizations and customer accounts.",                                                                                                                                                            "include_in_ai": "Y", "preferred_for_ai": "N", "status": "ACTIVE", "default_rank": 40},
    {"object_name": "V_STATUS_CODE_LOOKUP",    "object_type": "VIEW", "business_name": "Status Code",              "short_description": "Lookup of status codes and status descriptions.",                                                                                                                                                                                "include_in_ai": "Y", "preferred_for_ai": "N", "status": "ACTIVE", "default_rank": 50},
]

COLUMNS = [
    # V_ADDRESS_MASTER
    {"object_name": "V_ADDRESS_MASTER", "column_name": "ADDRESS_LINE1",    "business_name": "Address Line 1",    "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_ADDRESS_MASTER", "column_name": "CITY",             "business_name": "City",              "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_ADDRESS_MASTER", "column_name": "STATE_PROVINCE",   "business_name": "State / Province",  "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_ADDRESS_MASTER", "column_name": "POSTAL_CODE",      "business_name": "Postal Code",       "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 40},
    {"object_name": "V_ADDRESS_MASTER", "column_name": "COUNTRY_CODE",     "business_name": "Country Code",      "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 50},
    {"object_name": "V_ADDRESS_MASTER", "column_name": "ADDRESS_ID",       "business_name": "Address ID",        "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 90},
    # V_CUSTOMER_ACCOUNT
    {"object_name": "V_CUSTOMER_ACCOUNT", "column_name": "CUSTOMER_ACCOUNT_NUMBER", "business_name": "Customer Account Number", "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_CUSTOMER_ACCOUNT", "column_name": "CUSTOMER_NAME",           "business_name": "Customer Name",           "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_CUSTOMER_ACCOUNT", "column_name": "CUSTOMER_TYPE",           "business_name": "Customer Type",           "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_CUSTOMER_ACCOUNT", "column_name": "STATUS_CODE",             "business_name": "Status Code",             "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 40},
    {"object_name": "V_CUSTOMER_ACCOUNT", "column_name": "ORGANIZATION_ID",         "business_name": "Organization ID",         "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 50},
    {"object_name": "V_CUSTOMER_ACCOUNT", "column_name": "CUSTOMER_ACCOUNT_ID",     "business_name": "Customer Account ID",     "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 90},
    {"object_name": "V_CUSTOMER_ACCOUNT", "column_name": "BILLING_ADDRESS_ID",      "business_name": "Billing Address ID",      "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 91},
    {"object_name": "V_CUSTOMER_ACCOUNT", "column_name": "SHIPPING_ADDRESS_ID",     "business_name": "Shipping Address ID",     "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 92},
    # V_CUSTOMER_ORDER_SUMMARY
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY", "column_name": "CUSTOMER_ACCOUNT_NUMBER", "business_name": "Customer Account Number", "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY", "column_name": "CUSTOMER_NAME",           "business_name": "Customer Name",           "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY", "column_name": "CUSTOMER_TYPE",           "business_name": "Customer Type",           "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY", "column_name": "ORGANIZATION_NAME",       "business_name": "Organization Name",       "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 40},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY", "column_name": "ORDER_COUNT",             "business_name": "Order Count",             "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 50},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY", "column_name": "TOTAL_ORDER_AMOUNT",      "business_name": "Total Order Amount",      "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 60},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY", "column_name": "FIRST_ORDER_DATE",        "business_name": "First Order Date",        "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 70},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY", "column_name": "MOST_RECENT_ORDER_DATE",  "business_name": "Most Recent Order Date",  "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 80},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY", "column_name": "CUSTOMER_STATUS_CODE",    "business_name": "Customer Status Code",    "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 90},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY", "column_name": "CUSTOMER_ACCOUNT_ID",     "business_name": "Customer Account ID",     "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 91},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY", "column_name": "ORGANIZATION_ID",         "business_name": "Organization ID",         "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 92},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY", "column_name": "ORGANIZATION_CODE",       "business_name": "Organization Code",       "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 93},
    # V_INVENTORY_BALANCE
    {"object_name": "V_INVENTORY_BALANCE", "column_name": "LOCATION_CODE",       "business_name": "Location Code",       "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_INVENTORY_BALANCE", "column_name": "PRODUCT_SKU_ID",      "business_name": "Product SKU ID",      "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_INVENTORY_BALANCE", "column_name": "QUANTITY_ON_HAND",    "business_name": "Quantity On Hand",    "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_INVENTORY_BALANCE", "column_name": "REORDER_THRESHOLD",   "business_name": "Reorder Threshold",   "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 40},
    {"object_name": "V_INVENTORY_BALANCE", "column_name": "STATUS_CODE",         "business_name": "Status Code",         "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 50},
    {"object_name": "V_INVENTORY_BALANCE", "column_name": "INVENTORY_BALANCE_ID","business_name": "Inventory Balance ID","is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 90},
    # V_INVENTORY_STATUS
    {"object_name": "V_INVENTORY_STATUS", "column_name": "LOCATION_CODE",          "business_name": "Location Code",          "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "SKU_CODE",               "business_name": "SKU Code",               "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "SKU_NAME",               "business_name": "SKU Name",               "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "PRODUCT_NAME",           "business_name": "Product Name",           "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 40},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "PRODUCT_CATEGORY",       "business_name": "Product Category",       "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 50},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "QUANTITY_ON_HAND",       "business_name": "Quantity On Hand",       "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 60},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "REORDER_THRESHOLD",      "business_name": "Reorder Threshold",      "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 70},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "INVENTORY_HEALTH",       "business_name": "Inventory Health",       "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 80},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "UNIT_PRICE",             "business_name": "Unit Price",             "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 90},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "INVENTORY_BALANCE_ID",   "business_name": "Inventory Balance ID",   "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 91},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "PRODUCT_SKU_ID",         "business_name": "Product SKU ID",         "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 92},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "PRODUCT_ID",             "business_name": "Product ID",             "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 93},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "PRODUCT_CODE",           "business_name": "Product Code",           "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 94},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "INVENTORY_STATUS_CODE",  "business_name": "Inventory Status Code",  "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 95},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "SKU_STATUS_CODE",        "business_name": "SKU Status Code",        "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 96},
    {"object_name": "V_INVENTORY_STATUS", "column_name": "PRODUCT_STATUS_CODE",    "business_name": "Product Status Code",    "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 97},
    # V_INVOICE_HEADER
    {"object_name": "V_INVOICE_HEADER", "column_name": "INVOICE_ID",            "business_name": "Invoice ID",            "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 5},
    {"object_name": "V_INVOICE_HEADER", "column_name": "INVOICE_NUMBER",        "business_name": "Invoice Number",        "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_INVOICE_HEADER", "column_name": "CUSTOMER_ACCOUNT_ID",   "business_name": "Customer Account ID",   "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_INVOICE_HEADER", "column_name": "ORDER_ID",              "business_name": "Order ID",              "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_INVOICE_HEADER", "column_name": "INVOICE_DATE",          "business_name": "Invoice Date",          "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 40},
    {"object_name": "V_INVOICE_HEADER", "column_name": "DUE_DATE",              "business_name": "Due Date",              "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 50},
    {"object_name": "V_INVOICE_HEADER", "column_name": "STATUS_CODE",           "business_name": "Status Code",           "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 60},
    {"object_name": "V_INVOICE_HEADER", "column_name": "INVOICE_TOTAL_AMOUNT",  "business_name": "Invoice Total Amount",  "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 70},
    # V_ORDER_DETAIL
    {"object_name": "V_ORDER_DETAIL", "column_name": "ORDER_ID",              "business_name": "Order ID",              "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 5},
    {"object_name": "V_ORDER_DETAIL", "column_name": "ORDER_NUMBER",          "business_name": "Order Number",          "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_ORDER_DETAIL", "column_name": "ORDER_DATE",            "business_name": "Order Date",            "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_ORDER_DETAIL", "column_name": "CUSTOMER_ACCOUNT_NUMBER","business_name": "Customer Account Number","is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_ORDER_DETAIL", "column_name": "CUSTOMER_ACCOUNT_ID",   "business_name": "Customer Account ID",   "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 31},
    {"object_name": "V_ORDER_DETAIL", "column_name": "CUSTOMER_NAME",         "business_name": "Customer Name",         "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 40},
    {"object_name": "V_ORDER_DETAIL", "column_name": "CUSTOMER_TYPE",         "business_name": "Customer Type",         "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 45},
    {"object_name": "V_ORDER_DETAIL", "column_name": "ORGANIZATION_NAME",     "business_name": "Organization Name",     "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 50},
    {"object_name": "V_ORDER_DETAIL", "column_name": "ORGANIZATION_ID",       "business_name": "Organization ID",       "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 51},
    {"object_name": "V_ORDER_DETAIL", "column_name": "ORGANIZATION_CODE",     "business_name": "Organization Code",     "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 52},
    {"object_name": "V_ORDER_DETAIL", "column_name": "SKU_CODE",              "business_name": "SKU Code",              "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 60},
    {"object_name": "V_ORDER_DETAIL", "column_name": "ORDER_LINE_ITEM_ID",    "business_name": "Order Line Item ID",    "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 61},
    {"object_name": "V_ORDER_DETAIL", "column_name": "LINE_NUMBER",           "business_name": "Line Number",           "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 62},
    {"object_name": "V_ORDER_DETAIL", "column_name": "PRODUCT_SKU_ID",        "business_name": "Product SKU ID",        "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 63},
    {"object_name": "V_ORDER_DETAIL", "column_name": "SKU_NAME",              "business_name": "SKU Name",              "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 70},
    {"object_name": "V_ORDER_DETAIL", "column_name": "PRODUCT_NAME",          "business_name": "Product Name",          "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 80},
    {"object_name": "V_ORDER_DETAIL", "column_name": "PRODUCT_ID",            "business_name": "Product ID",            "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 81},
    {"object_name": "V_ORDER_DETAIL", "column_name": "PRODUCT_CODE",          "business_name": "Product Code",          "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 82},
    {"object_name": "V_ORDER_DETAIL", "column_name": "PRODUCT_CATEGORY",      "business_name": "Product Category",      "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 90},
    {"object_name": "V_ORDER_DETAIL", "column_name": "QUANTITY",              "business_name": "Quantity",              "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 100},
    {"object_name": "V_ORDER_DETAIL", "column_name": "UNIT_PRICE",            "business_name": "Unit Price",            "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 110},
    {"object_name": "V_ORDER_DETAIL", "column_name": "LINE_TOTAL",            "business_name": "Line Total",            "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 120},
    {"object_name": "V_ORDER_DETAIL", "column_name": "ORDER_TOTAL_AMOUNT",    "business_name": "Order Total Amount",    "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 130},
    {"object_name": "V_ORDER_DETAIL", "column_name": "ORDER_STATUS_CODE",     "business_name": "Order Status Code",     "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 140},
    {"object_name": "V_ORDER_DETAIL", "column_name": "LINE_STATUS_CODE",      "business_name": "Line Status Code",      "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 145},
    # V_ORDER_HEADER
    {"object_name": "V_ORDER_HEADER", "column_name": "ORDER_NUMBER",        "business_name": "Order Number",        "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_ORDER_HEADER", "column_name": "CUSTOMER_ACCOUNT_ID", "business_name": "Customer Account ID", "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_ORDER_HEADER", "column_name": "ORDER_DATE",          "business_name": "Order Date",          "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_ORDER_HEADER", "column_name": "STATUS_CODE",         "business_name": "Status Code",         "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 40},
    {"object_name": "V_ORDER_HEADER", "column_name": "ORDER_TOTAL_AMOUNT",  "business_name": "Order Total Amount",  "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 50},
    {"object_name": "V_ORDER_HEADER", "column_name": "ORDER_ID",            "business_name": "Order ID",            "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 90},
    # V_ORDER_LINE_ITEM
    {"object_name": "V_ORDER_LINE_ITEM", "column_name": "LINE_NUMBER",          "business_name": "Line Number",          "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_ORDER_LINE_ITEM", "column_name": "PRODUCT_SKU_ID",       "business_name": "Product SKU ID",       "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_ORDER_LINE_ITEM", "column_name": "QUANTITY",             "business_name": "Quantity",             "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_ORDER_LINE_ITEM", "column_name": "UNIT_PRICE",           "business_name": "Unit Price",           "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 40},
    {"object_name": "V_ORDER_LINE_ITEM", "column_name": "LINE_TOTAL",           "business_name": "Line Total",           "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 50},
    {"object_name": "V_ORDER_LINE_ITEM", "column_name": "STATUS_CODE",          "business_name": "Status Code",          "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 60},
    {"object_name": "V_ORDER_LINE_ITEM", "column_name": "ORDER_ID",             "business_name": "Order ID",             "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 80},
    {"object_name": "V_ORDER_LINE_ITEM", "column_name": "ORDER_LINE_ITEM_ID",   "business_name": "Order Line Item ID",   "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 90},
    # V_ORGANIZATION
    {"object_name": "V_ORGANIZATION", "column_name": "ORGANIZATION_CODE",  "business_name": "Organization Code",  "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_ORGANIZATION", "column_name": "ORGANIZATION_NAME",  "business_name": "Organization Name",  "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_ORGANIZATION", "column_name": "ORGANIZATION_TYPE",  "business_name": "Organization Type",  "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_ORGANIZATION", "column_name": "STATUS_CODE",        "business_name": "Status Code",        "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 40},
    {"object_name": "V_ORGANIZATION", "column_name": "ORGANIZATION_ID",    "business_name": "Organization ID",    "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 90},
    {"object_name": "V_ORGANIZATION", "column_name": "PRIMARY_ADDRESS_ID", "business_name": "Primary Address ID", "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 91},
    # V_PAYMENT_TRANSACTION
    {"object_name": "V_PAYMENT_TRANSACTION", "column_name": "PAYMENT_REFERENCE",       "business_name": "Payment Reference",       "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_PAYMENT_TRANSACTION", "column_name": "INVOICE_ID",              "business_name": "Invoice ID",              "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_PAYMENT_TRANSACTION", "column_name": "PAYMENT_DATE",            "business_name": "Payment Date",            "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_PAYMENT_TRANSACTION", "column_name": "PAYMENT_METHOD",          "business_name": "Payment Method",          "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 40},
    {"object_name": "V_PAYMENT_TRANSACTION", "column_name": "STATUS_CODE",             "business_name": "Status Code",             "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 50},
    {"object_name": "V_PAYMENT_TRANSACTION", "column_name": "PAYMENT_AMOUNT",          "business_name": "Payment Amount",          "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 60},
    {"object_name": "V_PAYMENT_TRANSACTION", "column_name": "PAYMENT_TRANSACTION_ID",  "business_name": "Payment Transaction ID",  "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 91},
    # V_PRODUCT_MASTER
    {"object_name": "V_PRODUCT_MASTER", "column_name": "PRODUCT_CODE",        "business_name": "Product Code",        "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_PRODUCT_MASTER", "column_name": "PRODUCT_NAME",        "business_name": "Product Name",        "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_PRODUCT_MASTER", "column_name": "PRODUCT_DESCRIPTION", "business_name": "Product Description", "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_PRODUCT_MASTER", "column_name": "PRODUCT_CATEGORY",    "business_name": "Product Category",    "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 40},
    {"object_name": "V_PRODUCT_MASTER", "column_name": "STATUS_CODE",         "business_name": "Status Code",         "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 50},
    {"object_name": "V_PRODUCT_MASTER", "column_name": "PRODUCT_ID",          "business_name": "Product ID",          "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 90},
    # V_PRODUCT_SKU
    {"object_name": "V_PRODUCT_SKU", "column_name": "SKU_CODE",         "business_name": "SKU Code",         "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_PRODUCT_SKU", "column_name": "SKU_NAME",         "business_name": "SKU Name",         "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_PRODUCT_SKU", "column_name": "SKU_DESCRIPTION",  "business_name": "SKU Description",  "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_PRODUCT_SKU", "column_name": "UNIT_PRICE",       "business_name": "Unit Price",       "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 40},
    {"object_name": "V_PRODUCT_SKU", "column_name": "STATUS_CODE",      "business_name": "Status Code",      "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 50},
    {"object_name": "V_PRODUCT_SKU", "column_name": "PRODUCT_ID",       "business_name": "Product ID",       "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 80},
    {"object_name": "V_PRODUCT_SKU", "column_name": "PRODUCT_SKU_ID",   "business_name": "Product SKU ID",   "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 90},
    # V_SHIPMENT_HEADER
    {"object_name": "V_SHIPMENT_HEADER", "column_name": "SHIPMENT_NUMBER",        "business_name": "Shipment Number",        "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_SHIPMENT_HEADER", "column_name": "ORDER_ID",               "business_name": "Order ID",               "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_SHIPMENT_HEADER", "column_name": "SHIPMENT_DATE",          "business_name": "Shipment Date",          "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_SHIPMENT_HEADER", "column_name": "STATUS_CODE",            "business_name": "Status Code",            "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 40},
    {"object_name": "V_SHIPMENT_HEADER", "column_name": "SHIP_TO_ADDRESS_ID",     "business_name": "Ship To Address ID",     "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 50},
    {"object_name": "V_SHIPMENT_HEADER", "column_name": "SHIPMENT_TOTAL_AMOUNT",  "business_name": "Shipment Total Amount",  "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 60},
    {"object_name": "V_SHIPMENT_HEADER", "column_name": "SHIPMENT_ID",            "business_name": "Shipment ID",            "is_identifier": "Y", "is_human_readable": "N", "is_default_select": "N", "is_filterable": "Y", "display_rank": 90},
    # V_STATUS_CODE_LOOKUP
    {"object_name": "V_STATUS_CODE_LOOKUP", "column_name": "STATUS_CODE",        "business_name": "Status Code",        "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 10},
    {"object_name": "V_STATUS_CODE_LOOKUP", "column_name": "STATUS_TYPE",        "business_name": "Status Type",        "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 20},
    {"object_name": "V_STATUS_CODE_LOOKUP", "column_name": "STATUS_DESCRIPTION", "business_name": "Status Description", "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "Y", "is_filterable": "Y", "display_rank": 30},
    {"object_name": "V_STATUS_CODE_LOOKUP", "column_name": "IS_ACTIVE",          "business_name": "Is Active",          "is_identifier": "N", "is_human_readable": "Y", "is_default_select": "N", "is_filterable": "Y", "display_rank": 40},
]

ALIASES = [
    {"object_name": "V_ADDRESS_MASTER",        "alias_term": "address",                  "alias_weight": 20},
    {"object_name": "V_ADDRESS_MASTER",        "alias_term": "location",                 "alias_weight": 10},
    {"object_name": "V_CUSTOMER_ACCOUNT",      "alias_term": "customer account",         "alias_weight": 25},
    {"object_name": "V_CUSTOMER_ACCOUNT",      "alias_term": "customer",                 "alias_weight": 20},
    {"object_name": "V_CUSTOMER_ACCOUNT",      "alias_term": "account",                  "alias_weight": 15},
    {"object_name": "V_CUSTOMER_ACCOUNT",      "alias_term": "client",                   "alias_weight": 12},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY","alias_term": "customer order summary",   "alias_weight": 28},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY","alias_term": "top customers",            "alias_weight": 22},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY","alias_term": "customer revenue summary", "alias_weight": 20},
    {"object_name": "V_CUSTOMER_ORDER_SUMMARY","alias_term": "customer summary",         "alias_weight": 18},
    {"object_name": "V_INVENTORY_BALANCE",     "alias_term": "inventory balance",        "alias_weight": 28},
    {"object_name": "V_INVENTORY_BALANCE",     "alias_term": "inventory",                "alias_weight": 26},
    {"object_name": "V_INVENTORY_BALANCE",     "alias_term": "stock",                    "alias_weight": 24},
    {"object_name": "V_INVENTORY_BALANCE",     "alias_term": "on hand",                  "alias_weight": 20},
    {"object_name": "V_INVENTORY_BALANCE",     "alias_term": "reorder",                  "alias_weight": 18},
    {"object_name": "V_INVENTORY_STATUS",      "alias_term": "inventory status",         "alias_weight": 28},
    {"object_name": "V_INVENTORY_STATUS",      "alias_term": "out of stock",             "alias_weight": 24},
    {"object_name": "V_INVENTORY_STATUS",      "alias_term": "stock status",             "alias_weight": 24},
    {"object_name": "V_INVENTORY_STATUS",      "alias_term": "low stock",                "alias_weight": 22},
    {"object_name": "V_INVOICE_HEADER",        "alias_term": "invoice",                  "alias_weight": 26},
    {"object_name": "V_INVOICE_HEADER",        "alias_term": "invoices",                 "alias_weight": 22},
    {"object_name": "V_INVOICE_HEADER",        "alias_term": "amount due",               "alias_weight": 18},
    {"object_name": "V_INVOICE_HEADER",        "alias_term": "billing",                  "alias_weight": 18},
    {"object_name": "V_ORDER_DETAIL",          "alias_term": "order detail",             "alias_weight": 26},
    {"object_name": "V_ORDER_DETAIL",          "alias_term": "order details",            "alias_weight": 24},
    {"object_name": "V_ORDER_DETAIL",          "alias_term": "sales detail",             "alias_weight": 18},
    {"object_name": "V_ORDER_DETAIL",          "alias_term": "order lines with customer","alias_weight": 16},
    {"object_name": "V_ORDER_HEADER",          "alias_term": "order",                    "alias_weight": 25},
    {"object_name": "V_ORDER_HEADER",          "alias_term": "customer order",           "alias_weight": 24},
    {"object_name": "V_ORDER_HEADER",          "alias_term": "orders",                   "alias_weight": 22},
    {"object_name": "V_ORDER_HEADER",          "alias_term": "sales order",              "alias_weight": 20},
    {"object_name": "V_ORDER_HEADER",          "alias_term": "purchase",                 "alias_weight": 10},
    {"object_name": "V_ORDER_LINE_ITEM",       "alias_term": "order line item",          "alias_weight": 26},
    {"object_name": "V_ORDER_LINE_ITEM",       "alias_term": "order line",               "alias_weight": 24},
    {"object_name": "V_ORDER_LINE_ITEM",       "alias_term": "line item",                "alias_weight": 22},
    {"object_name": "V_ORDER_LINE_ITEM",       "alias_term": "ordered item",             "alias_weight": 18},
    {"object_name": "V_ORDER_LINE_ITEM",       "alias_term": "order detail",             "alias_weight": 16},
    {"object_name": "V_ORGANIZATION",          "alias_term": "organization",             "alias_weight": 20},
    {"object_name": "V_ORGANIZATION",          "alias_term": "org",                      "alias_weight": 18},
    {"object_name": "V_ORGANIZATION",          "alias_term": "company",                  "alias_weight": 15},
    {"object_name": "V_PAYMENT_TRANSACTION",   "alias_term": "payment transaction",      "alias_weight": 28},
    {"object_name": "V_PAYMENT_TRANSACTION",   "alias_term": "payment",                  "alias_weight": 26},
    {"object_name": "V_PAYMENT_TRANSACTION",   "alias_term": "payments",                 "alias_weight": 22},
    {"object_name": "V_PAYMENT_TRANSACTION",   "alias_term": "cash receipt",             "alias_weight": 14},
    {"object_name": "V_PRODUCT_MASTER",        "alias_term": "product master",           "alias_weight": 22},
    {"object_name": "V_PRODUCT_MASTER",        "alias_term": "product",                  "alias_weight": 20},
    {"object_name": "V_PRODUCT_MASTER",        "alias_term": "products",                 "alias_weight": 18},
    {"object_name": "V_PRODUCT_MASTER",        "alias_term": "item",                     "alias_weight": 10},
    {"object_name": "V_PRODUCT_SKU",           "alias_term": "product sku",              "alias_weight": 26},
    {"object_name": "V_PRODUCT_SKU",           "alias_term": "sku",                      "alias_weight": 25},
    {"object_name": "V_PRODUCT_SKU",           "alias_term": "stock keeping unit",       "alias_weight": 20},
    {"object_name": "V_PRODUCT_SKU",           "alias_term": "variant",                  "alias_weight": 16},
    {"object_name": "V_PRODUCT_SKU",           "alias_term": "priced item",              "alias_weight": 12},
    {"object_name": "V_SHIPMENT_HEADER",       "alias_term": "shipment",                 "alias_weight": 25},
    {"object_name": "V_SHIPMENT_HEADER",       "alias_term": "shipments",                "alias_weight": 22},
    {"object_name": "V_SHIPMENT_HEADER",       "alias_term": "delivery",                 "alias_weight": 18},
    {"object_name": "V_SHIPMENT_HEADER",       "alias_term": "delivered order",          "alias_weight": 14},
    {"object_name": "V_STATUS_CODE_LOOKUP",    "alias_term": "status code",              "alias_weight": 25},
    {"object_name": "V_STATUS_CODE_LOOKUP",    "alias_term": "status",                   "alias_weight": 20},
    {"object_name": "V_STATUS_CODE_LOOKUP",    "alias_term": "state",                    "alias_weight": 8},
]

EXAMPLES = [
    {
        "preferred_object_name": "V_ADDRESS_MASTER",
        "question_text": "List addresses in a city",
        "exemplar_sql": (
            "select\n"
            "    address_line1,\n"
            "    city,\n"
            "    state_province,\n"
            "    postal_code,\n"
            "    country_code\n"
            "from v_address_master\n"
            "where city = :city\n"
            "order by address_line1"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_CUSTOMER_ACCOUNT",
        "question_text": "List customers by organization",
        "exemplar_sql": (
            "select\n"
            "    organization_id,\n"
            "    customer_account_number,\n"
            "    customer_name\n"
            "from v_customer_account\n"
            "order by organization_id, customer_name"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_CUSTOMER_ACCOUNT",
        "question_text": "Show active customer accounts",
        "exemplar_sql": (
            "select\n"
            "    customer_account_number,\n"
            "    customer_name,\n"
            "    customer_type,\n"
            "    status_code\n"
            "from v_customer_account\n"
            "where status_code = 'ACTIVE'\n"
            "order by customer_name"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_CUSTOMER_ORDER_SUMMARY",
        "question_text": "Show customers with no orders",
        "exemplar_sql": (
            "select\n"
            "    customer_account_number,\n"
            "    customer_name,\n"
            "    organization_name,\n"
            "    order_count,\n"
            "    total_order_amount\n"
            "from v_customer_order_summary\n"
            "where order_count = 0\n"
            "order by customer_name"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_CUSTOMER_ORDER_SUMMARY",
        "question_text": "Show top customers by order amount",
        "exemplar_sql": (
            "select\n"
            "    customer_account_number,\n"
            "    customer_name,\n"
            "    organization_name,\n"
            "    order_count,\n"
            "    total_order_amount\n"
            "from v_customer_order_summary\n"
            "order by total_order_amount desc, customer_name"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_INVENTORY_BALANCE",
        "question_text": "Show active inventory balances",
        "exemplar_sql": (
            "select\n"
            "    product_sku_id,\n"
            "    location_code,\n"
            "    quantity_on_hand,\n"
            "    reorder_threshold\n"
            "from v_inventory_balance\n"
            "where status_code = 'ACTIVE'\n"
            "order by location_code, product_sku_id"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_INVENTORY_BALANCE",
        "question_text": "Show inventory by location",
        "exemplar_sql": (
            "select\n"
            "    location_code,\n"
            "    product_sku_id,\n"
            "    quantity_on_hand,\n"
            "    reorder_threshold,\n"
            "    status_code\n"
            "from v_inventory_balance\n"
            "order by location_code, product_sku_id"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_INVENTORY_BALANCE",
        "question_text": "Show low inventory items",
        "exemplar_sql": (
            "select\n"
            "    product_sku_id,\n"
            "    location_code,\n"
            "    quantity_on_hand,\n"
            "    reorder_threshold,\n"
            "    status_code\n"
            "from v_inventory_balance\n"
            "where quantity_on_hand <= reorder_threshold\n"
            "order by quantity_on_hand, product_sku_id"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_INVENTORY_STATUS",
        "question_text": "Show low stock items by location",
        "exemplar_sql": (
            "select\n"
            "    location_code,\n"
            "    sku_code,\n"
            "    sku_name,\n"
            "    product_name,\n"
            "    quantity_on_hand,\n"
            "    reorder_threshold,\n"
            "    inventory_health\n"
            "from v_inventory_status\n"
            "where inventory_health in ('LOW_STOCK', 'OUT_OF_STOCK')\n"
            "order by location_code, quantity_on_hand, sku_code"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_INVOICE_HEADER",
        "question_text": "Show invoices by due date",
        "exemplar_sql": (
            "select\n"
            "    invoice_number,\n"
            "    customer_account_id,\n"
            "    invoice_date,\n"
            "    due_date,\n"
            "    status_code,\n"
            "    invoice_total_amount\n"
            "from v_invoice_header\n"
            "order by due_date, invoice_number"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_INVOICE_HEADER",
        "question_text": "Show total invoice amount by status",
        "exemplar_sql": (
            "select\n"
            "    status_code,\n"
            "    sum(invoice_total_amount) as total_invoice_amount\n"
            "from v_invoice_header\n"
            "group by status_code\n"
            "order by status_code"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_ORDER_DETAIL",
        "question_text": "Show order detail by customer",
        "exemplar_sql": (
            "select\n"
            "    order_number,\n"
            "    order_date,\n"
            "    customer_account_number,\n"
            "    customer_name,\n"
            "    sku_code,\n"
            "    sku_name,\n"
            "    quantity,\n"
            "    line_total\n"
            "from v_order_detail\n"
            "order by order_date desc, order_number, line_number"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_ORDER_HEADER",
        "question_text": "List orders by customer",
        "exemplar_sql": (
            "select\n"
            "    customer_account_id,\n"
            "    order_number,\n"
            "    order_date,\n"
            "    order_total_amount,\n"
            "    status_code\n"
            "from v_order_header\n"
            "order by customer_account_id, order_date desc"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_ORDER_HEADER",
        "question_text": "Show recent orders",
        "exemplar_sql": (
            "select\n"
            "    order_number,\n"
            "    customer_account_id,\n"
            "    order_date,\n"
            "    status_code,\n"
            "    order_total_amount\n"
            "from v_order_header\n"
            "order by order_date desc, order_number"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_ORDER_HEADER",
        "question_text": "Show total order amount by status",
        "exemplar_sql": (
            "select\n"
            "    status_code,\n"
            "    sum(order_total_amount) as total_order_amount\n"
            "from v_order_header\n"
            "group by status_code\n"
            "order by status_code"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_ORDER_LINE_ITEM",
        "question_text": "Show line totals by order",
        "exemplar_sql": (
            "select\n"
            "    order_id,\n"
            "    line_number,\n"
            "    line_total\n"
            "from v_order_line_item\n"
            "order by order_id, line_number"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_ORDER_LINE_ITEM",
        "question_text": "Show order line items",
        "exemplar_sql": (
            "select\n"
            "    order_id,\n"
            "    line_number,\n"
            "    product_sku_id,\n"
            "    quantity,\n"
            "    unit_price,\n"
            "    line_total,\n"
            "    status_code\n"
            "from v_order_line_item\n"
            "order by order_id, line_number"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_ORDER_LINE_ITEM",
        "question_text": "Show total quantity ordered by SKU",
        "exemplar_sql": (
            "select\n"
            "    product_sku_id,\n"
            "    sum(quantity) as total_quantity\n"
            "from v_order_line_item\n"
            "group by product_sku_id\n"
            "order by total_quantity desc, product_sku_id"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_ORGANIZATION",
        "question_text": "Find organization by code",
        "exemplar_sql": (
            "select\n"
            "    organization_code,\n"
            "    organization_name,\n"
            "    organization_type,\n"
            "    status_code\n"
            "from v_organization\n"
            "where organization_code = :organization_code"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_PAYMENT_TRANSACTION",
        "question_text": "Show payments by date",
        "exemplar_sql": (
            "select\n"
            "    payment_reference,\n"
            "    invoice_id,\n"
            "    payment_date,\n"
            "    payment_method,\n"
            "    payment_amount,\n"
            "    status_code\n"
            "from v_payment_transaction\n"
            "order by payment_date desc, payment_reference"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_PAYMENT_TRANSACTION",
        "question_text": "Show payments by method",
        "exemplar_sql": (
            "select\n"
            "    payment_method,\n"
            "    count(*) as payment_count,\n"
            "    sum(payment_amount) as total_payment_amount\n"
            "from v_payment_transaction\n"
            "group by payment_method\n"
            "order by total_payment_amount desc, payment_method"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_PRODUCT_MASTER",
        "question_text": "List products by category",
        "exemplar_sql": (
            "select\n"
            "    product_category,\n"
            "    product_code,\n"
            "    product_name,\n"
            "    status_code\n"
            "from v_product_master\n"
            "order by product_category, product_name"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_PRODUCT_MASTER",
        "question_text": "Show all active products",
        "exemplar_sql": (
            "select\n"
            "    product_code,\n"
            "    product_name,\n"
            "    product_category,\n"
            "    status_code\n"
            "from v_product_master\n"
            "where status_code = 'ACTIVE'\n"
            "order by product_name"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_PRODUCT_SKU",
        "question_text": "Find SKU by code",
        "exemplar_sql": (
            "select\n"
            "    sku_code,\n"
            "    sku_name,\n"
            "    sku_description,\n"
            "    unit_price,\n"
            "    status_code\n"
            "from v_product_sku\n"
            "where sku_code = :sku_code"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_PRODUCT_SKU",
        "question_text": "Show SKU prices",
        "exemplar_sql": (
            "select\n"
            "    sku_code,\n"
            "    sku_name,\n"
            "    unit_price\n"
            "from v_product_sku\n"
            "order by unit_price desc, sku_name"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_PRODUCT_SKU",
        "question_text": "Show all active SKUs with prices",
        "exemplar_sql": (
            "select\n"
            "    sku_code,\n"
            "    sku_name,\n"
            "    unit_price,\n"
            "    status_code\n"
            "from v_product_sku\n"
            "where status_code = 'ACTIVE'\n"
            "order by sku_name"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_SHIPMENT_HEADER",
        "question_text": "List shipments by status",
        "exemplar_sql": (
            "select\n"
            "    status_code,\n"
            "    shipment_number,\n"
            "    shipment_date,\n"
            "    shipment_total_amount\n"
            "from v_shipment_header\n"
            "order by status_code, shipment_date desc"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_SHIPMENT_HEADER",
        "question_text": "Show recent shipments",
        "exemplar_sql": (
            "select\n"
            "    shipment_number,\n"
            "    order_id,\n"
            "    shipment_date,\n"
            "    status_code,\n"
            "    shipment_total_amount\n"
            "from v_shipment_header\n"
            "order by shipment_date desc, shipment_number"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_SHIPMENT_HEADER",
        "question_text": "Show shipment totals by order",
        "exemplar_sql": (
            "select\n"
            "    order_id,\n"
            "    shipment_number,\n"
            "    shipment_total_amount\n"
            "from v_shipment_header\n"
            "order by order_id, shipment_number"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_SHIPMENT_HEADER",
        "question_text": "Show shipments in transit with unpaid invoices",
        "exemplar_sql": (
            "select sh.shipment_number, sh.order_id, sh.shipment_date,\n"
            "    sh.status_code as shipment_status, inv.invoice_number,\n"
            "    inv.status_code as invoice_status, inv.invoice_total_amount,\n"
            "    pay.payment_reference, pay.status_code as payment_status\n"
            "from v_shipment_header sh\n"
            "join v_invoice_header inv on sh.order_id = inv.order_id\n"
            "left join v_payment_transaction pay on inv.invoice_id = pay.invoice_id\n"
            "where sh.status_code in ('IN_TRANSIT', 'DELIVERED')\n"
            "and (pay.invoice_id is null or pay.status_code != 'COMPLETED')\n"
            "order by sh.shipment_date desc, sh.shipment_number"
        ),
        "is_enabled": "Y",
    },
    {
        "preferred_object_name": "V_STATUS_CODE_LOOKUP",
        "question_text": "Show all active status codes",
        "exemplar_sql": (
            "select\n"
            "    status_code,\n"
            "    status_type,\n"
            "    status_description\n"
            "from v_status_code_lookup\n"
            "where is_active = 'Y'\n"
            "order by status_type, status_code"
        ),
        "is_enabled": "Y",
    },
]

# ---------------------------------------------------------------------------
# MERGE SQL
# ---------------------------------------------------------------------------

_SQL_OBJECT = """
MERGE INTO t_semantic_object tgt
USING DUAL
ON (tgt.object_name = :object_name)
WHEN MATCHED THEN UPDATE SET
    object_type       = :object_type,
    business_name     = :business_name,
    short_description = :short_description,
    include_in_ai     = :include_in_ai,
    preferred_for_ai  = :preferred_for_ai,
    status            = :status,
    default_rank      = :default_rank
WHEN NOT MATCHED THEN INSERT
    (object_name, object_type, business_name, short_description,
     include_in_ai, preferred_for_ai, status, default_rank)
VALUES
    (:object_name, :object_type, :business_name, :short_description,
     :include_in_ai, :preferred_for_ai, :status, :default_rank)
""".strip()

_SQL_COLUMN = """
MERGE INTO t_semantic_column tgt
USING DUAL
ON (tgt.object_name = :object_name AND tgt.column_name = :column_name)
WHEN MATCHED THEN UPDATE SET
    business_name     = :business_name,
    is_identifier     = :is_identifier,
    is_human_readable = :is_human_readable,
    is_default_select = :is_default_select,
    is_filterable     = :is_filterable,
    display_rank      = :display_rank
WHEN NOT MATCHED THEN INSERT
    (object_name, column_name, business_name,
     is_identifier, is_human_readable, is_default_select, is_filterable, display_rank)
VALUES
    (:object_name, :column_name, :business_name,
     :is_identifier, :is_human_readable, :is_default_select, :is_filterable, :display_rank)
""".strip()

_SQL_ALIAS = """
MERGE INTO t_semantic_object_alias tgt
USING DUAL
ON (tgt.object_name = :object_name AND tgt.alias_term = :alias_term)
WHEN MATCHED THEN UPDATE SET
    alias_weight = :alias_weight
WHEN NOT MATCHED THEN INSERT
    (object_name, alias_term, alias_weight)
VALUES
    (:object_name, :alias_term, :alias_weight)
""".strip()

_SQL_EXAMPLE = """
MERGE INTO t_semantic_example_question tgt
USING DUAL
ON (tgt.preferred_object_name = :preferred_object_name
    AND tgt.question_text = :question_text)
WHEN MATCHED THEN UPDATE SET
    exemplar_sql = :exemplar_sql,
    is_enabled   = :is_enabled
WHEN NOT MATCHED THEN INSERT
    (preferred_object_name, question_text, exemplar_sql, is_enabled)
VALUES
    (:preferred_object_name, :question_text, :exemplar_sql, :is_enabled)
""".strip()

_TRUNCATE_ORDER = [
    "TRUNCATE TABLE t_semantic_example_question",
    "TRUNCATE TABLE t_semantic_object_alias",
    "TRUNCATE TABLE t_semantic_column",
    "TRUNCATE TABLE t_semantic_object",
]

# ---------------------------------------------------------------------------
# Core logic
# ---------------------------------------------------------------------------

def seed(dry_run: bool = False, reset: bool = False) -> None:
    if dry_run:
        _dry_run_print()
        return

    try:
        from config.settings import settings
        import oracledb
        conn = oracledb.connect(
            user=settings.db_user,
            password=settings.db_password,
            dsn=settings.db_dsn,
        )
    except Exception as exc:
        print(f"Error: could not connect to database — {exc}")
        sys.exit(1)

    try:
        cur = conn.cursor()

        if reset:
            print("Resetting semantic tables...")
            for stmt in _TRUNCATE_ORDER:
                cur.execute(stmt)
                print(f"  {stmt}")

        try:
            for row in OBJECTS:
                cur.execute(_SQL_OBJECT, row)
            for row in COLUMNS:
                cur.execute(_SQL_COLUMN, row)
            for row in ALIASES:
                cur.execute(_SQL_ALIAS, row)
            for row in EXAMPLES:
                cur.execute(_SQL_EXAMPLE, row)
            conn.commit()
        except Exception as exc:
            conn.rollback()
            print(f"Error: MERGE failed — {exc}")
            print("Transaction rolled back. No partial writes committed.")
            sys.exit(1)

    finally:
        conn.close()

    print(
        f"Seeded: {len(OBJECTS)} objects, {len(COLUMNS)} columns, "
        f"{len(ALIASES)} aliases, {len(EXAMPLES)} examples."
    )


def _dry_run_print() -> None:
    for row in OBJECTS:
        print(f"[DRY RUN] {_SQL_OBJECT.splitlines()[0]} {row}")
    for row in COLUMNS:
        print(f"[DRY RUN] {_SQL_COLUMN.splitlines()[0]} {row}")
    for row in ALIASES:
        print(f"[DRY RUN] {_SQL_ALIAS.splitlines()[0]} {row}")
    for row in EXAMPLES:
        safe = {k: (v[:60] + "...") if isinstance(v, str) and len(v) > 60 else v
                for k, v in row.items()}
        print(f"[DRY RUN] {_SQL_EXAMPLE.splitlines()[0]} {safe}")
    print(
        f"\n[DRY RUN] Would seed: {len(OBJECTS)} objects, {len(COLUMNS)} columns, "
        f"{len(ALIASES)} aliases, {len(EXAMPLES)} examples."
    )


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Seed the AI SQL Assistant semantic layer.")
    parser.add_argument("--dry-run", action="store_true", help="Print SQL without executing.")
    parser.add_argument("--reset",   action="store_true", help="Truncate all 4 semantic tables before seeding.")
    args = parser.parse_args()
    seed(dry_run=args.dry_run, reset=args.reset)
