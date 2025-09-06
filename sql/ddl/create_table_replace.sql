CREATE SCHEMA `dim`;

CREATE SCHEMA `fact`;

CREATE TABLE `dim`.`customers` (
  `customer_id` INT AUTO_INCREMENT COMMENT 'Mã khách hàng',
  `customer_name` VARCHAR(80) NOT NULL COMMENT 'Tên khách hàng',
  `email` VARCHAR(50)
);

CREATE TABLE `dim`.`manufacturers` (
  `manufacturer_id` INT AUTO_INCREMENT COMMENT 'Mã nhà sản xuất',
  `manufacturer_name` VARCHAR(80) NOT NULL COMMENT 'Tên nhà sản xuất'
);

CREATE TABLE `dim`.`categories` (
  `category_id` INT AUTO_INCREMENT COMMENT 'Mã danh mục sản phẩm',
  `category_name` VARCHAR(80) NOT NULL COMMENT 'Tên danh mục sản phẩm'
);

CREATE TABLE `dim`.`products` (
  `product_id` INT AUTO_INCREMENT COMMENT 'Mã sản phẩm',
  `product_name` VARCHAR(255) NOT NULL COMMENT 'Tên sản phẩm'
);

CREATE TABLE `dim`.`skus` (
  `sku_id` INT AUTO_INCREMENT COMMENT 'Mã SKU',
  `sku_description` VARCHAR(500) NOT NULL COMMENT 'Mô tả chi SKU',
  `product_id` INT NOT NULL COMMENT 'Mã sản phẩm SKU thuộc về',
  `product_name` VARCHAR(255) NOT NULL COMMENT 'Tên sản phẩm',
  `product_type` VARCHAR(255) NOT NULL COMMENT 'Loại sản phẩm'
);

CREATE TABLE `dim`.`payment_methods` (
  `payment_method` SMALLINT AUTO_INCREMENT COMMENT 'Mã phương thức thanh toán',
  `description` VARCHAR(255) NOT NULL COMMENT 'Mô tả chi tiết phương thức thanh toán'
);

CREATE TABLE `dim`.`payment_status` (
  `payment_status` SMALLINT AUTO_INCREMENT COMMENT 'Mã trạng thái thanh toán',
  `description` VARCHAR(255) NOT NULL COMMENT 'Mô tả chi tiết trạng thái thanh toán'
);

CREATE TABLE `dim`.`order_status` (
  `order_status` SMALLINT AUTO_INCREMENT COMMENT 'Mã trạng thái đơn hàng',
  `description` VARCHAR(255) NOT NULL COMMENT 'Mô tả chi tiết trạng thái đơn hàng'
);

CREATE TABLE `dim`.`warehouses` (
  `warehouse_id` SMALLINT AUTO_INCREMENT COMMENT 'Mã kho giao hàng',
  `warehouse_name` VARCHAR(100) NOT NULL COMMENT 'Tên kho giao hàng'
);

CREATE TABLE `dim`.`provinces` (
  `province_id` SMALLINT AUTO_INCREMENT COMMENT 'Mã tỉnh thành',
  `province_name` VARCHAR(100) NOT NULL COMMENT 'Tên tỉnh thành'
);

CREATE TABLE `dim`.`districts` (
  `district_id` SMALLINT AUTO_INCREMENT COMMENT 'Mã quận huyện',
  `district_name` VARCHAR(100) NOT NULL COMMENT 'Tên quận huyện',
  `province_id` SMALLINT NOT NULL COMMENT 'Mã tỉnh thành quận huyện thuộc về'
);

CREATE TABLE `fact`.`sale_details` (
  `id` INT AUTO_INCREMENT,
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
  `quantity` SMALLLINT NOT NULL COMMENT 'Số lượng mua',
  `amount` INT NOT NULL COMMENT 'Số tiền chưa trừ giảm giá, đã nhân số lượng',
  `discount` DECIMAL(10,3) NOT NULL DEFAULT 0 COMMENT 'Số tiền giảm giá, đã nhân số lượng',
  `net_amount` DECIMAL(10,3) NOT NULL COMMENT 'Số tiền đã trừ giảm giá, đã nhân số lượng',
  `final_amount` INT NOT NULL COMMENT 'Số tiền cần thu',
  `received_amount` INT NOT NULL COMMENT 'Số tiền đã thu (đối với phương thức COD)',
  `delivery_amount` INT NOT NULL COMMENT 'Số tiền vận chuyển',
  `traffic_source` VARCHAR(50) NOT NULL COMMENT 'Nguồn truy cập website',
  `utm_source` VARCHAR(255) NOT NULL COMMENT 'Đối tác giới thiệu khách mua hàng'
);

CREATE UNIQUE INDEX ``dim`.customers_index_0` ON `dim`.`customers` (`email`);

ALTER TABLE `dim`.`customers` COMMENT = 'Bảng thông tin khách hàng.
Một dòng là thông tin của 1 khách hàng.';

ALTER TABLE `dim`.`manufacturers` COMMENT = 'Bảng thông tin nhà sản xuất.
Một dòng là thông tin của 1 nhà sản xuất.';

ALTER TABLE `dim`.`categories` COMMENT = 'Bảng thông tin danh mục sản phẩm.
Một dòng là thông tin của 1 danh mục sản phẩm.';

ALTER TABLE `dim`.`products` COMMENT = 'Bảng thông tin sản phẩm.
Một dòng là thông tin của 1 sản phẩm.';

ALTER TABLE `dim`.`skus` COMMENT = 'Bảng thông tin sản phẩm.
Một dòng là thông tin của 1 sản phẩm.';

ALTER TABLE `dim`.`payment_methods` COMMENT = 'Bảng thông tin phương thức thanh toán.
Một dòng là thông tin của 1 phương thức thanh toán.';

ALTER TABLE `dim`.`payment_status` COMMENT = 'Bảng thông tin phương thức thanh toán.
Một dòng là thông tin của 1 phương thức thanh toán.';

ALTER TABLE `dim`.`order_status` COMMENT = 'Bảng thông tin phương thức thanh toán.
Một dòng là thông tin của 1 phương thức thanh toán.';

ALTER TABLE `dim`.`warehouses` COMMENT = 'Bảng thông tin kho giao hàng của công ty.
Một dòng là thông tin của 1 kho giao hàng.';

ALTER TABLE `dim`.`provinces` COMMENT = 'Bảng thông tin tỉnh thành.
Một dòng là thông tin của 1 tỉnh thành.';

ALTER TABLE `dim`.`districts` COMMENT = 'Bảng thông tin tỉnh thành.
Một dòng là thông tin của 1 tỉnh thành.';

ALTER TABLE `fact`.`sale_details` COMMENT = 'Bảng thông tin đơn hàng.
Một dòng là thông tin 1 sản phẩm trong 1 đơn hàng.';

ALTER TABLE `fact`.`sale_details` ADD FOREIGN KEY (`customer_id`) REFERENCES `dim`.`customers` (`customer_id`);

ALTER TABLE `fact`.`sale_details` ADD FOREIGN KEY (`sku_id`) REFERENCES `dim`.`skus` (`sku_id`);

ALTER TABLE `fact`.`sale_details` ADD FOREIGN KEY (`product_id`) REFERENCES `dim`.`products` (`product_id`);

ALTER TABLE `fact`.`sale_details` ADD FOREIGN KEY (`category_id`) REFERENCES `dim`.`categories` (`category_id`);

ALTER TABLE `fact`.`sale_details` ADD FOREIGN KEY (`manufacturer_id`) REFERENCES `dim`.`manufacturers` (`manufacturer_id`);

ALTER TABLE `fact`.`sale_details` ADD FOREIGN KEY (`warehouse_id`) REFERENCES `dim`.`warehouses` (`warehouse_id`);

ALTER TABLE `fact`.`sale_details` ADD FOREIGN KEY (`payment_method`) REFERENCES `dim`.`payment_methods` (`payment_method`);

ALTER TABLE `fact`.`sale_details` ADD FOREIGN KEY (`payment_status`) REFERENCES `dim`.`payment_status` (`payment_status`);

ALTER TABLE `fact`.`sale_details` ADD FOREIGN KEY (`order_status`) REFERENCES `dim`.`order_status` (`order_status`);

ALTER TABLE `fact`.`sale_details` ADD FOREIGN KEY (`delivery_province_id`) REFERENCES `dim`.`provinces` (`province_id`);

ALTER TABLE `fact`.`sale_details` ADD FOREIGN KEY (`delivery_district_id`) REFERENCES `dim`.`districts` (`district_id`);

ALTER TABLE `dim`.`products` ADD FOREIGN KEY (`product_id`) REFERENCES `dim`.`categories` (`category_id`);

ALTER TABLE `dim`.`skus` ADD FOREIGN KEY (`product_id`) REFERENCES `dim`.`products` (`product_id`);

ALTER TABLE `dim`.`districts` ADD FOREIGN KEY (`district_id`) REFERENCES `dim`.`provinces` (`province_id`);
