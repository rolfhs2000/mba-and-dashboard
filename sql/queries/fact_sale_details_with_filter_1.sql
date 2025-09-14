SELECT order_id,
    dsk.sku_description,
    order_date
FROM fact_sale_details AS fsd
LEFT JOIN dim_products AS dpr
    ON fsd.product_id = dpr.product_id
LEFT JOIN dim_skus AS dsk
    ON fsd.sku_id = dsk.sku_id
WHERE
    order_date BETWEEN "2021-06-01 00:00:00" AND "2025-06-30 23:59:59"
    AND order_status = 2
    AND dpr.is_gift = 0;