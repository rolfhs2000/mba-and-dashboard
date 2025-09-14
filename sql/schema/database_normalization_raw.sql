CREATE TABLE `fact_sale_details` (
  `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã tự tăng.
Một dòng là một sản phẩm của đơn hàng.',
  `order_id` INT NOT NULL COMMENT 'Mã đơn hàng',
  `order_date` DATETIME NOT NULL COMMENT 'Ngày khách hàng đặt hàng',
  `customer_id` INT NOT NULL COMMENT 'Mã khách hàng',
  `sku_id` INT NOT NULL COMMENT 'Mã SKU',
  `product_id` INT NOT NULL COMMENT 'Mã sản phẩm',
  `category_id` INT NOT NULL COMMENT 'Mã danh mục sản phẩm',
  `manufacturer_id` INT NOT NULL COMMENT 'Mã nhà sản xuất',
  `warehouse_id` SMALLINT NOT NULL COMMENT 'Mã kho giao hàng',
  `payment_method` SMALLINT NOT NULL COMMENT 'Phương thức thanh toán',
  `payment_status` SMALLINT NOT NULL COMMENT 'Trạng thái thanh toán',
  `order_status` SMALLINT NOT NULL COMMENT 'Trạng thái đơn hàng',
  `delivery_district_id` SMALLINT NOT NULL COMMENT 'Mã quận huyện nhận hàng',
  `delivery_province_id` SMALLINT NOT NULL COMMENT 'Mã tỉnh thành nhận hàng',
  `quantity` SMALLINT NOT NULL COMMENT 'Số lượng mua',
  `amount` INT NOT NULL COMMENT 'Số tiền chưa trừ giảm giá, đã nhân số lượng',
  `discount` DECIMAL(10,3) NOT NULL DEFAULT 0 COMMENT 'Số tiền giảm giá, đã nhân số lượng',
  `net_amount` DECIMAL(10,3) NOT NULL COMMENT 'Số tiền đã trừ giảm giá, đã nhân số lượng',
  `final_amount` INT NOT NULL COMMENT 'Số tiền cần thu',
  `received_amount` INT NOT NULL COMMENT 'Số tiền đã thu (đối với phương thức COD)',
  `delivery_amount` INT NOT NULL COMMENT 'Số tiền vận chuyển',
  `traffic_source` VARCHAR(50) NOT NULL COMMENT 'Nguồn truy cập website',
  `utm_source` VARCHAR(255) NOT NULL COMMENT 'Đối tác giới thiệu khách mua hàng'
);

CREATE TABLE `dim_customers` (
  `customer_id` INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã khách hàng',
  `customer_name` VARCHAR(80) NOT NULL COMMENT 'Tên khách hàng',
  `email` VARCHAR(50) COMMENT 'Email của khách hàng'
);

CREATE TABLE `dim_manufacturers` (
  `manufacturer_id` INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã nhà sản xuất',
  `manufacturer_name` VARCHAR(80) NOT NULL COMMENT 'Tên nhà sản xuất'
);

CREATE TABLE `dim_skus` (
  `sku_id` INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã SKU',
  `product_id` INT NOT NULL COMMENT 'Mã sản phẩm SKU thuộc về',
  `sku_description` VARCHAR(500) NOT NULL COMMENT 'Mô tả chi SKU',
  `is_gift` SMALLINT NOT NULL COMMENT 'Đánh dấu sản phẩm là quà tặng (0: Sản phẩm thông thường, 1: Sản phẩm quà tặng)',
  `product_name` VARCHAR(255) NOT NULL COMMENT 'Tên sản phẩm',
  `product_type` VARCHAR(255) NOT NULL COMMENT 'Loại sản phẩm'
);

CREATE TABLE `bridge_categories_products` (
  `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã tự tăng',
  `product_id` INT COMMENT 'Mã sản phẩm',
  `category_id` INT COMMENT 'Mã danh mục sản phẩm'
);

CREATE TABLE `dim_products` (
  `product_id` INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã sản phẩm',
  `product_name` VARCHAR(255) NOT NULL COMMENT 'Tên sản phẩm',
  `is_gift` SMALLINT NOT NULL COMMENT 'Đánh dấu sản phẩm là quà tặng (0: Sản phẩm thông thường, 1: Sản phẩm quà tặng)'
);

CREATE TABLE `dim_categories` (
  `category_id` INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã danh mục sản phẩm',
  `category_name` VARCHAR(80) NOT NULL COMMENT 'Tên danh mục sản phẩm'
);

CREATE TABLE `dim_payment_methods` (
  `payment_method` SMALLINT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã phương thức thanh toán',
  `description` VARCHAR(255) NOT NULL COMMENT 'Mô tả chi tiết phương thức thanh toán'
);

CREATE TABLE `dim_payment_status` (
  `payment_status` SMALLINT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã trạng thái thanh toán',
  `description` VARCHAR(255) NOT NULL COMMENT 'Mô tả chi tiết trạng thái thanh toán'
);

CREATE TABLE `dim_order_status` (
  `order_status` SMALLINT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã trạng thái đơn hàng',
  `description` VARCHAR(255) NOT NULL COMMENT 'Mô tả chi tiết trạng thái đơn hàng'
);

CREATE TABLE `dim_warehouses` (
  `warehouse_id` SMALLINT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã kho giao hàng',
  `warehouse_name` VARCHAR(100) NOT NULL COMMENT 'Tên kho giao hàng'
);

CREATE TABLE `dim_districts` (
  `district_id` SMALLINT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã quận huyện',
  `district_name` VARCHAR(100) NOT NULL COMMENT 'Tên quận huyện',
  `province_id` SMALLINT NOT NULL COMMENT 'Mã tỉnh thành quận huyện thuộc về'
);

CREATE TABLE `dim_provinces` (
  `province_id` SMALLINT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã tỉnh thành',
  `province_name` VARCHAR(100) NOT NULL COMMENT 'Tên tỉnh thành'
);

CREATE TABLE `stat_buy_togethers` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã tự tăng. Một dòng là 1 kết hợp mua [antecedents] thì sẽ mua kèm [consequents]',
  `antecedents` VARCHAR(500) COMMENT 'Sản phẩm mua trước',
  `consequents` VARCHAR(500) COMMENT 'Sản phẩm được mua kèm theo',
  `antecedent_support` DECIMAL(5,2) COMMENT 'Tỷ lệ số đơn hàng chứa sản phẩm so với tổng số đơn hàng khảo sát',
  `consequent_support` DECIMAL(5,2) COMMENT 'Tỷ lệ số đơn hàng chứa sản phẩm so với tổng số đơn hàng khảo sát',
  `support` DECIMAL(5,2) COMMENT 'Tỷ lệ số đơn hàng chứa kết hợp so với tổng số đơn hàng. Support cao nghĩa là kết hợp xuất hiện thường xuyên',
  `confidence` DECIMAL(5,2) COMMENT 'Xác suất rằng khi khách hàng mua kết hợp A thì cũng mua kết hợp B. Công thức: confidence(A→B) = support(A∪B) / support(A)',
  `lift` DECIMAL(5,2) COMMENT 'Đo lường mức độ liên kết thực sự giữa A và B so với kỳ vọng nếu A và B độc lập. Lift > 1 nghĩa là A và B có mối liên hệ mạnh hơn ngẫu nhiên, lift < 1 là yếu hơn ngẫu nhiên',
  `time_scope` VARCHAR(30),
  `created_at` DATE
);

CREATE INDEX `fact_sale_details_index_0` ON `fact_sale_details` (`order_id`);

CREATE INDEX `fact_sale_details_index_1` ON `fact_sale_details` (`order_date`);

CREATE INDEX `fact_sale_details_index_2` ON `fact_sale_details` (`customer_id`);

CREATE INDEX `fact_sale_details_index_3` ON `fact_sale_details` (`product_id`);

CREATE UNIQUE INDEX `dim_customers_index_4` ON `dim_customers` (`email`);

CREATE INDEX `stat_buy_togethers_index_5` ON `stat_buy_togethers` (`support`);

CREATE INDEX `stat_buy_togethers_index_6` ON `stat_buy_togethers` (`confidence`);

CREATE INDEX `stat_buy_togethers_index_7` ON `stat_buy_togethers` (`lift`);

ALTER TABLE `fact_sale_details` COMMENT = 'Bảng thông tin đơn hàng. Một dòng là thông tin 1 sản phẩm trong 1 đơn hàng.';

ALTER TABLE `dim_customers` COMMENT = 'Bảng thông tin khách hàng.
Một dòng là thông tin của 1 khách hàng.';

ALTER TABLE `dim_manufacturers` COMMENT = 'Bảng thông tin nhà sản xuất.
Một dòng là thông tin của 1 nhà sản xuất.';

ALTER TABLE `dim_skus` COMMENT = 'Bảng thông tin sản phẩm. Một dòng là thông tin của 1 sản phẩm.';

ALTER TABLE `bridge_categories_products` COMMENT = 'Bảng bridge danh mục sản phẩm, sản phẩm.';

ALTER TABLE `dim_products` COMMENT = 'Bảng thông tin sản phẩm.
Một dòng là thông tin của 1 sản phẩm.';

ALTER TABLE `dim_categories` COMMENT = 'Bảng thông tin danh mục sản phẩm.
Một dòng là thông tin của 1 danh mục sản phẩm.';

ALTER TABLE `dim_payment_methods` COMMENT = 'Bảng thông tin phương thức thanh toán.
Một dòng là thông tin của 1 phương thức thanh toán.';

ALTER TABLE `dim_payment_status` COMMENT = 'Bảng thông tin phương thức thanh toán.
Một dòng là thông tin của 1 phương thức thanh toán.';

ALTER TABLE `dim_order_status` COMMENT = 'Bảng thông tin phương thức thanh toán.
Một dòng là thông tin của 1 phương thức thanh toán.';

ALTER TABLE `dim_warehouses` COMMENT = 'Bảng thông tin kho giao hàng của công ty.
Một dòng là thông tin của 1 kho giao hàng.';

ALTER TABLE `dim_districts` COMMENT = 'Bảng thông tin tỉnh thành.
Một dòng là thông tin của 1 tỉnh thành.';

ALTER TABLE `dim_provinces` COMMENT = 'Bảng thông tin tỉnh thành.
Một dòng là thông tin của 1 tỉnh thành.';

ALTER TABLE `stat_buy_togethers` COMMENT = 'Bảng thống kê các sản phẩm thường được mua cùng nhau trên cùng một hoá đơn. Mục đích: Phát hiện các nhóm sản phẩm thường được mua cùng nhau để đề xuất bán chéo, tối ưu trưng bày sản phẩm, xây dựng chương trình khuyến mãi,...';

ALTER TABLE `fact_sale_details` ADD FOREIGN KEY (`customer_id`) REFERENCES `dim_customers` (`customer_id`);

ALTER TABLE `fact_sale_details` ADD FOREIGN KEY (`sku_id`) REFERENCES `dim_skus` (`sku_id`);

ALTER TABLE `fact_sale_details` ADD FOREIGN KEY (`product_id`) REFERENCES `dim_products` (`product_id`);

ALTER TABLE `fact_sale_details` ADD FOREIGN KEY (`category_id`) REFERENCES `dim_categories` (`category_id`);

ALTER TABLE `fact_sale_details` ADD FOREIGN KEY (`manufacturer_id`) REFERENCES `dim_manufacturers` (`manufacturer_id`);

ALTER TABLE `fact_sale_details` ADD FOREIGN KEY (`warehouse_id`) REFERENCES `dim_warehouses` (`warehouse_id`);

ALTER TABLE `fact_sale_details` ADD FOREIGN KEY (`payment_method`) REFERENCES `dim_payment_methods` (`payment_method`);

ALTER TABLE `fact_sale_details` ADD FOREIGN KEY (`payment_status`) REFERENCES `dim_payment_status` (`payment_status`);

ALTER TABLE `fact_sale_details` ADD FOREIGN KEY (`order_status`) REFERENCES `dim_order_status` (`order_status`);

ALTER TABLE `fact_sale_details` ADD FOREIGN KEY (`delivery_province_id`) REFERENCES `dim_provinces` (`province_id`);

ALTER TABLE `fact_sale_details` ADD FOREIGN KEY (`delivery_district_id`) REFERENCES `dim_districts` (`district_id`);

ALTER TABLE `bridge_categories_products` ADD FOREIGN KEY (`product_id`) REFERENCES `dim_products` (`product_id`);

ALTER TABLE `bridge_categories_products` ADD FOREIGN KEY (`category_id`) REFERENCES `dim_categories` (`category_id`);

ALTER TABLE `dim_skus` ADD FOREIGN KEY (`product_id`) REFERENCES `dim_products` (`product_id`);

ALTER TABLE `dim_districts` ADD FOREIGN KEY (`province_id`) REFERENCES `dim_provinces` (`province_id`);
