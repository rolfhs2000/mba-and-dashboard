DROP TABLE IF EXISTS `stat_buy_togethers`;
CREATE TABLE `stat_buy_togethers` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'Mã tự tăng. Một dòng là 1 kết hợp mua [antecedents] thì sẽ mua kèm [consequents]',
  `antecedents` VARCHAR(500) COMMENT 'Sản phẩm mua trước',
  `consequents` VARCHAR(500) COMMENT 'Sản phẩm được mua kèm theo',
  `antecedent_support` DECIMAL(5,2) COMMENT 'Tỷ lệ số đơn hàng chứa sản phẩm so với tổng số đơn hàng khảo sát',
  `consequent_support` DECIMAL(5,2) COMMENT 'Tỷ lệ số đơn hàng chứa sản phẩm so với tổng số đơn hàng khảo sát',
  `support` DECIMAL(5,2) COMMENT 'Tỷ lệ số đơn hàng chứa kết hợp so với tổng số đơn hàng. Support cao nghĩa là kết hợp xuất hiện thường xuyên',
  `confidence` DECIMAL(5,2) COMMENT 'Xác suất rằng khi khách hàng mua kết hợp A thì cũng mua kết hợp B. Công thức: confidence(A→B) = support(A∪B) / support(A)',
  `lift` DECIMAL(5,2) COMMENT 'Đo lường mức độ liên kết thực sự giữa A và B so với kỳ vọng nếu A và B độc lập. Lift > 1 nghĩa là A và B có mối liên hệ mạnh hơn ngẫu nhiên, lift < 1 là yếu hơn ngẫu nhiên',
  `time_scope_order_date` VARCHAR(50),
  `created_at` DATETIME,
  `updated_at` DATETIME);
CREATE INDEX `stat_buy_togethers_index_support` ON `stat_buy_togethers` (`support`);
CREATE INDEX `stat_buy_togethers_index_confidence` ON `stat_buy_togethers` (`confidence`);
CREATE INDEX `stat_buy_togethers_index_lift` ON `stat_buy_togethers` (`lift`);
ALTER TABLE `stat_buy_togethers` COMMENT = 'Bảng thống kê các sản phẩm thường được mua cùng nhau trên cùng một hoá đơn. Mục đích: Phát hiện các nhóm sản phẩm thường được mua cùng nhau để đề xuất bán chéo, tối ưu trưng bày sản phẩm, xây dựng chương trình khuyến mãi,...';