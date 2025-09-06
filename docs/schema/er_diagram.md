erDiagram

    dim_customers {
        INT customer_id PK "Mã khách hàng"
        VARCHAR customer_name "Tên khách hàng"
        VARCHAR email "Email"
    }

    dim_manufacturers {
        INT manufacturer_id PK "Mã nhà sản xuất"
        VARCHAR manufacturer_name "Tên nhà sản xuất"
    }

    dim_categories {
        INT category_id PK "Mã danh mục sản phẩm"
        VARCHAR category_name "Tên danh mục sản phẩm"
    }

    dim_products {
        INT product_id PK "Mã sản phẩm"
        VARCHAR product_name "Tên sản phẩm"
    }

    dim_skus {
        INT sku_id PK "Mã SKU"
        VARCHAR sku_description "Mô tả chi SKU"
        INT product_id FK "Mã sản phẩm SKU thuộc về"
        VARCHAR product_name "Tên sản phẩm"
        VARCHAR product_type "Loại sản phẩm"
    }

    dim_payment_methods {
        SMALLINT payment_method PK "Mã phương thức thanh toán"
        VARCHAR description "Mô tả chi tiết phương thức thanh toán"
    }

    dim_payment_status {
        SMALLINT payment_status PK "Mã trạng thái thanh toán"
        VARCHAR description "Mô tả chi tiết trạng thái thanh toán"
    }

    dim_order_status {
        SMALLINT order_status PK "Mã trạng thái đơn hàng"
        VARCHAR description "Mô tả chi tiết trạng thái đơn hàng"
    }

    dim_warehouses {
        SMALLINT warehouse_id PK "Mã kho giao hàng"
        VARCHAR warehouse_name "Tên kho giao hàng"
    }

    dim_provinces {
        SMALLINT province_id PK "Mã tỉnh thành"
        VARCHAR province_name "Tên tỉnh thành"
    }

    dim_districts {
        SMALLINT district_id PK "Mã quận huyện"
        VARCHAR district_name "Tên quận huyện"
        SMALLINT province_id FK "Mã tỉnh thành quận huyện thuộc về"
    }

    fact_sale_details {
        INT id PK "ID"
        INT order_id "Mã đơn hàng"
        DATETIME order_date "Ngày khách hàng đặt hàng"
        INT customer_id FK "Mã khách hàng"
        INT sku_id FK "Mã SKU"
        INT product_id FK "Mã sản phẩm"
        INT category_id FK "Mã danh mục sản phẩm"
        INT manufacturer_id FK "Mã nhà sản xuất"
        SMALLINT warehouse_id FK "Mã kho giao hàng"
        SMALLINT payment_method FK "Phương thức thanh toán"
        SMALLINT payment_status FK "Trạng thái thanh toán"
        SMALLINT order_status FK "Trạng thái đơn hàng"
        SMALLINT delivery_district_id FK "Mã quận huyện nhận hàng"
        SMALLINT delivery_province_id FK "Mã tỉnh thành nhận hàng"
        SMALLINT quantity "Số lượng mua"
        INT amount "Số tiền chưa trừ giảm giá"
        DECIMAL discount "Số tiền giảm giá"
        DECIMAL net_amount "Số tiền đã trừ giảm giá"
        INT final_amount "Số tiền cần thu"
        INT received_amount "Số tiền đã thu"
        INT delivery_amount "Số tiền vận chuyển"
        VARCHAR traffic_source "Nguồn truy cập website"
        VARCHAR utm_source "Đối tác giới thiệu khách mua hàng"
    }

    %% Relationships
    fact_sale_details }o--|| dim_customers : "customer_id"
    fact_sale_details }o--|| dim_skus : "sku_id"
    fact_sale_details }o--|| dim_products : "product_id"
    fact_sale_details }o--|| dim_categories : "category_id"
    fact_sale_details }o--|| dim_manufacturers : "manufacturer_id"
    fact_sale_details }o--|| dim_warehouses : "warehouse_id"
    fact_sale_details }o--|| dim_payment_methods : "payment_method"
    fact_sale_details }o--|| dim_payment_status : "payment_status"
    fact_sale_details }o--|| dim_order_status : "order_status"
    fact_sale_details }o--|| dim_provinces : "delivery_province_id"
    fact_sale_details }o--|| dim_districts : "delivery_district_id"
    dim_skus }o--|| dim_products : "product_id"
    dim_districts }o--|| dim_provinces : "province_id"