1. TỔNG QUAN
   Project này làm end-to-end việc database hoá 1 file CSV vào DB -> Kéo data từ DB về làm Visualize Dashboard -> Kéo data từ DB về làm Phân tích (ở đây phân tích bài toán giỏ hàng), sau đó lưu ngược kết quả lên DB.
   Mục tiêu:

- Database hoá các file quản lý thủ công trong doanh nghiệp: excel, csv,... về 1 database để quản lý tập trung.
- Làm dashboard để theo dõi tình hình đơn hàng.
- Phân tích giỏ hàng để tìm các sản phẩm thường được mua cùng, từ đó stakeholders có thể lên chiến lược combo, khuyến mãi,... phù hợp với mục tiêu kinh doanh.

2. HƯỚNG DẪN CHẠY PROJECT
   Step 1. Clone project về.
   Step 2. Vào src/db_connection/connectors/mysql_aws_mba_and_dashboard.py: Tại đây, thay đổi thông tin kết nối bằng Database của bạn, ở đây mình đang kết nối đến MySQL.
   (Nhớ pip các package trong requirements.txt)
   Step 3. Run file src/database_denormalization.ipynb: Run file này để chạy script chuyển đổi file data/raw/mba.csv -> ghi vào DB.
   Step 4. Run file src/stat_buy_togethers.ipynb: Run file này để đọc lại data bán hàng đã ghi ở bước 3 -> Chạy model phân tích giỏ hàng (FPGrowth) -> Ghi kết quả phân tích vào DB.

3. PROJECT STRUCTURE
   MBA-AND-DASHBOARD/
   ├── README.md # Giới thiệu, hướng dẫn sử dụng project
   ├── requirements.txt # Danh sách các thư viện Python cần cài đặt
   ├── data/ # Chứa dữ liệu gốc, dữ liệu xuất ra, v.v
   │ ├── raw/ # Dữ liệu thô
   │ ├── processed/ # Dữ liệu đã xử lý
   ├── docs/ # Tài liệu, mô tả schema, hướng dẫn
   │ ├── schema/
   │ │ ├── data_dictionary.csv # Field definitions (auto-generated)
   │ │ ├── er_diagram.md # Entity-relationship diagrams
   ├── notebooks/ # Chứa các file Jupyter Notebook để trình bày, thử nghiệm, phân tích
   │ ├── database_normalization.ipynb # Code for convert csv file to database version
   │ ├── stat_buy_togethers.ipynb # Code find product be bought together
   ├── sql/ # Các file truy vấn SQL, script tạo bảng, schema
   │ ├── queries/ # Chứa câu query để truy vấn dữ liệu
   │ ├── schema/ # Chứa các script SQL tạo bảng
   ├── src/ # Source code chính (python modules)
   │ ├── analysis/ # Chứa các hàm phân tích chuyên sâu (FP-Growth, Association Rule, v.v)
   │ │ ├── market_basket.py # Các hàm về phân tích FP-Growth, Association Rule
   │ ├── db_connection/ # Thông tin kết nối từng loại DB
   │ | ├── connectors/
   │ │ │ ├── mysql_aws_mba_and_dashboard.py # Thông tin kết nối DB
   │ │ ├── db_utils.py # Hàm tiện ích cho DB (read_data, create_table, ...)
   │ ├── utils/ # Các hàm tiện ích khác (nếu có)
   │ │ ├── general.py # Hàm tiện ích chung của project
   ├── .gitignore
   ├── .vscode/

Account read_only (MySQL)
(Just for education purpose, please don't spam!)
SERVER = 'mba-and-dashboard.cn4i0gwkgmxu.ap-southeast-2.rds.amazonaws.com'
PORT = 3306
DATABASE = 'mba_and_dashboard'
USERNAME = 'read_only'
PASSWORD = '123456789!'
