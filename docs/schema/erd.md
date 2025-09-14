TABLE fact_sale_details {
NOTE: "Bảng thông tin đơn hàng. Một dòng là thông tin 1 sản phẩm trong 1 đơn hàng."
id INT [PK, INCREMENT, Note: "Mã tự tăng.\nMột dòng là một sản phẩm của đơn hàng."]
order_id INT [Note: "Mã đơn hàng", NOT NULL]
order_date DATETIME [Note: "Ngày khách hàng đặt hàng", NOT NULL]
customer_id INT [Note: "Mã khách hàng", NOT NULL]
sku_id INT [Note: "Mã SKU", NOT NULL]
product_id INT [Note: "Mã sản phẩm", NOT NULL]
category_id INT [Note: "Mã danh mục sản phẩm", NOT NULL]
manufacturer_id INT [Note: "Mã nhà sản xuất", NOT NULL]
warehouse_id SMALLINT [Note: "Mã kho giao hàng", NOT NULL]
payment_method SMALLINT [Note: "Phương thức thanh toán", NOT NULL]
payment_status SMALLINT [Note: "Trạng thái thanh toán", NOT NULL]
order_status SMALLINT [Note: "Trạng thái đơn hàng", NOT NULL]
delivery_district_id SMALLINT [Note: "Mã quận huyện nhận hàng", NOT NULL]
delivery_province_id SMALLINT [Note: "Mã tỉnh thành nhận hàng", NOT NULL]
quantity SMALLINT [Note: "Số lượng mua", NOT NULL]
amount INT [Note: "Số tiền chưa trừ giảm giá, đã nhân số lượng", NOT NULL]
discount DECIMAL(10,3) [Note: "Số tiền giảm giá, đã nhân số lượng", NOT NULL, DEFAULT: 0]
net_amount DECIMAL(10,3) [Note: "Số tiền đã trừ giảm giá, đã nhân số lượng", NOT NULL]
final_amount INT [Note: "Số tiền cần thu", NOT NULL]
received_amount INT [Note: "Số tiền đã thu (đối với phương thức COD)", NOT NULL]
delivery_amount INT [Note: "Số tiền vận chuyển", NOT NULL]
traffic_source VARCHAR(50) [Note: "Nguồn truy cập website", NOT NULL]
utm_source VARCHAR(255) [Note: "Đối tác giới thiệu khách mua hàng", NOT NULL]
indexes {
order_id
order_date
customer_id
product_id
}
}

TABLE dim_customers {
NOTE: "Bảng thông tin khách hàng.\nMột dòng là thông tin của 1 khách hàng."
customer_id INT [PK, INCREMENT, Note: "Mã khách hàng"]
customer_name VARCHAR(80) [Note: "Tên khách hàng", NOT NULL]
email VARCHAR(50) [Note: "Email của khách hàng"]
indexes {
email [UNIQUE]
}
}

TABLE dim_manufacturers {
NOTE: "Bảng thông tin nhà sản xuất.\nMột dòng là thông tin của 1 nhà sản xuất."
manufacturer_id INT [PK, INCREMENT, Note: "Mã nhà sản xuất"]
manufacturer_name VARCHAR(80) [Note: "Tên nhà sản xuất", NOT NULL]
}

TABLE dim_skus {
NOTE: "Bảng thông tin sản phẩm. Một dòng là thông tin của 1 sản phẩm."
sku_id INT [PK, INCREMENT, Note: "Mã SKU"]
product_id INT [Note: "Mã sản phẩm SKU thuộc về", NOT NULL]
sku_description VARCHAR(500) [Note: "Mô tả chi SKU", NOT NULL]
is_gift SMALLINT [Note: "Đánh dấu sản phẩm là quà tặng (0: Sản phẩm thông thường, 1: Sản phẩm quà tặng)", NOT NULL]
product_name VARCHAR(255) [Note: "Tên sản phẩm", NOT NULL]
product_type VARCHAR(255) [Note: "Loại sản phẩm", NOT NULL]
}

TABLE bridge_categories_products {
NOTE: "Bảng bridge danh mục sản phẩm, sản phẩm."
id INT [PK, INCREMENT, Note:"Mã tự tăng"]
product_id INT [Note: "Mã sản phẩm"]
category_id INT [Note: "Mã danh mục sản phẩm"]
}

TABLE dim_products {
NOTE: "Bảng thông tin sản phẩm.\nMột dòng là thông tin của 1 sản phẩm."
product_id INT [PK, INCREMENT, Note: "Mã sản phẩm"]
product_name VARCHAR(255) [Note: "Tên sản phẩm", NOT NULL]
is_gift SMALLINT [Note: "Đánh dấu sản phẩm là quà tặng (0: Sản phẩm thông thường, 1: Sản phẩm quà tặng)", NOT NULL]
}

TABLE dim_categories {
NOTE: "Bảng thông tin danh mục sản phẩm.\nMột dòng là thông tin của 1 danh mục sản phẩm."
category_id INT [PK, INCREMENT, Note: "Mã danh mục sản phẩm"]
category_name VARCHAR(80) [Note: "Tên danh mục sản phẩm", NOT NULL]
}

TABLE dim_payment_methods {
NOTE: "Bảng thông tin phương thức thanh toán.\nMột dòng là thông tin của 1 phương thức thanh toán."
payment_method SMALLINT [PK, INCREMENT, Note: "Mã phương thức thanh toán"]
description VARCHAR(255) [Note: "Mô tả chi tiết phương thức thanh toán", NOT NULL]
}

TABLE dim_payment_status {
NOTE: "Bảng thông tin phương thức thanh toán.\nMột dòng là thông tin của 1 phương thức thanh toán."
payment_status SMALLINT [PK, INCREMENT, Note: "Mã trạng thái thanh toán"]
description VARCHAR(255) [Note: "Mô tả chi tiết trạng thái thanh toán", NOT NULL]
}

TABLE dim_order_status {
NOTE: "Bảng thông tin phương thức thanh toán.\nMột dòng là thông tin của 1 phương thức thanh toán."
order_status SMALLINT [PK, INCREMENT, Note: "Mã trạng thái đơn hàng"]
description VARCHAR(255) [Note: "Mô tả chi tiết trạng thái đơn hàng", NOT NULL]
}

TABLE dim_warehouses {
NOTE: "Bảng thông tin kho giao hàng của công ty.\nMột dòng là thông tin của 1 kho giao hàng."
warehouse_id SMALLINT [PK, INCREMENT, Note: "Mã kho giao hàng"]
warehouse_name VARCHAR(100) [Note: "Tên kho giao hàng", NOT NULL]
}

TABLE dim_districts {
NOTE: "Bảng thông tin tỉnh thành.\nMột dòng là thông tin của 1 tỉnh thành."
district_id SMALLINT [PK, INCREMENT, Note: "Mã quận huyện"]
district_name VARCHAR(100) [Note: "Tên quận huyện", NOT NULL]
province_id SMALLINT [Note: "Mã tỉnh thành quận huyện thuộc về", NOT NULL]
}

TABLE dim_provinces {
NOTE: "Bảng thông tin tỉnh thành.\nMột dòng là thông tin của 1 tỉnh thành."
province_id SMALLINT [PK, INCREMENT, Note: "Mã tỉnh thành"]
province_name VARCHAR(100) [Note: "Tên tỉnh thành", NOT NULL]
}

TABLE stat_buy_togethers {
NOTE: "Bảng thống kê các sản phẩm thường được mua cùng nhau trên cùng một hoá đơn. Mục đích: Phát hiện các nhóm sản phẩm thường được mua cùng nhau để đề xuất bán chéo, tối ưu trưng bày sản phẩm, xây dựng chương trình khuyến mãi,..."
id BIGINT [PK, INCREMENT, Note: "Mã tự tăng. Một dòng là 1 kết hợp mua [antecedents] thì sẽ mua kèm [consequents]"]
antecedents VARCHAR(500) [Note: "Sản phẩm mua trước"]
consequents VARCHAR(500) [Note: "Sản phẩm được mua kèm theo"]
antecedent_support DECIMAL(5,2) [Note: "Tỷ lệ số đơn hàng chứa sản phẩm so với tổng số đơn hàng khảo sát"]
consequent_support DECIMAL(5,2) [Note: "Tỷ lệ số đơn hàng chứa sản phẩm so với tổng số đơn hàng khảo sát"]
support DECIMAL(5,2) [Note: "Tỷ lệ số đơn hàng chứa kết hợp so với tổng số đơn hàng. Support cao nghĩa là kết hợp xuất hiện thường xuyên"]
confidence DECIMAL(5,2) [Note: "Xác suất rằng khi khách hàng mua kết hợp A thì cũng mua kết hợp B. Công thức: confidence(A→B) = support(A∪B) / support(A)"]
lift DECIMAL(5,2) [Note: "Đo lường mức độ liên kết thực sự giữa A và B so với kỳ vọng nếu A và B độc lập. Lift > 1 nghĩa là A và B có mối liên hệ mạnh hơn ngẫu nhiên, lift < 1 là yếu hơn ngẫu nhiên"]
time_scope VARCHAR(30)
created_at DATE
indexes {
support
confidence
lift
}

}

Ref: fact_sale_details.customer_id > dim_customers.customer_id
Ref: fact_sale_details.sku_id > dim_skus.sku_id
Ref: fact_sale_details.product_id > dim_products.product_id
Ref: fact_sale_details.category_id > dim_categories.category_id
Ref: fact_sale_details.manufacturer_id > dim_manufacturers.manufacturer_id
Ref: fact_sale_details.warehouse_id > dim_warehouses.warehouse_id
Ref: fact_sale_details.payment_method > dim_payment_methods.payment_method
Ref: fact_sale_details.payment_status > dim_payment_status.payment_status
Ref: fact_sale_details.order_status > dim_order_status.order_status
Ref: fact_sale_details.delivery_province_id > dim_provinces.province_id
Ref: fact_sale_details.delivery_district_id > dim_districts.district_id

Ref: bridge_categories_products.product_id > dim_products.product_id
Ref: bridge_categories_products.category_id > dim_categories.category_id
Ref: dim_skus.product_id > dim_products.product_id
Ref: dim_districts.province_id > dim_provinces.province_id
