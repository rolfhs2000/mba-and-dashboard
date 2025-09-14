# %% [markdown]
# # Set up & Load Data

# %%
# Import Nessessary Libraries
import pandas as pd
pd.set_option("display.max_rows", None, "display.max_columns", None)
pd.set_option("display.max_colwidth", None)
import os
from db_connection.db_utils import get_connection, read_data, create_table, insert_df_to_db
from db_connection.connectors.mysql_aws_mba_and_dashboard import SERVER, PORT, DATABASE, USERNAME, PASSWORD

# %%
# Connect to DB
conn, cursor = get_connection(SERVER, PORT, DATABASE, USERNAME, PASSWORD)

# %%
# Read `fact_sale_details_with_filter_1`, filter completed orders & non-gift products & be ordered in June-2021
# Get query statement
sql_path = os.path.abspath(r".\sql\queries\fact_sale_details_with_filter_1.sql")
with open(sql_path, 'r', encoding='utf-8') as f:
    sqls = f.read()
# Execute query statement
df = read_data(sqls, conn, cursor)

# %% [markdown]
# # Market Basket Analysis - Lý thuyết
# (Bài toán phân tích giỏ hàng sử dụng thuật toán FP-Growth)
# 
# 1. FP-Growth Algorithm
# Cài đặt và chạy thuật toán FP-Growth để phân tích luật kết hợp (association rules) từ dữ liệu đơn hàng.
# 
# 2. Giải thích thuật toán FP-Growth và các chỉ số
# **FP-Growth** (Frequent Pattern Growth) là một thuật toán khai phá kết hợp phổ biến (frequent itemsets) trong dữ liệu đơn hàng, thường dùng trong phân tích giỏ hàng (market basket analysis). Thuật toán này giúp tìm ra các nhóm sản phẩm thường được mua cùng nhau mà không cần sinh tất cả các tập con ứng viên như Apriori, do đó nhanh và tiết kiệm bộ nhớ hơn.
# 
# 2.1 Ý nghĩa các chỉ số:
# - **Support (Độ phổ biến):** Tỷ lệ số đơn hàng chứa kết hợp so với tổng số đơn hàng. Support cao nghĩa là kết hợp xuất hiện thường xuyên.
# - **Confidence (Độ tin cậy):** Xác suất rằng khi khách hàng mua kết hợp A thì cũng mua kết hợp B. Công thức: confidence(A→B) = support(A∪B) / support(A).
# - **Lift (Độ nâng):** Đo lường mức độ liên kết thực sự giữa A và B so với kỳ vọng nếu A và B độc lập. Lift > 1 nghĩa là A và B có mối liên hệ mạnh hơn ngẫu nhiên, lift < 1 là yếu hơn ngẫu nhiên.
# 
# 2.2 Ứng dụng
# - Phát hiện các nhóm sản phẩm thường được mua cùng nhau để đề xuất bán chéo, tối ưu trưng bày sản phẩm, xây dựng chương trình khuyến mãi,...

# %% [markdown]
# # Implement FP-GROWTH

# %%
import analysis.market_basket as am
import datetime

# Chuẩn hóa dữ liệu
basket = am.prepare_data(df, item_col='sku_description', trans_col='order_id')

# Chạy FP-Growth
freq_itemsets = am.run_fp_growth(basket, min_support=0.01)
# Sinh luật kết hợp
rules = am.get_association_rules(freq_itemsets, metric="confidence", min_threshold=0.2)

# %%
# Processing results to insert to DB
# Add needed column to insert to DB
# Add `time_scope`
from_order_date = str(df.order_date.min().date())
to_order_date = str(df.order_date.max().date())
rules['time_scope_order_date'] = from_order_date + "->" + to_order_date
# Add `created_at`
rules['created_at'] = datetime.datetime.now()
rules['updated_at'] = datetime.datetime.now()
# Convert data type
rules['antecedents'] = rules['antecedents'].apply(lambda x: ', '.join(map(str, x)))
rules['consequents'] = rules['consequents'].apply(lambda x: ', '.join(map(str, x)))

# %% [markdown]
# # Load Data to DB

# %%
# Create Table
# Get DDL
sql_path = os.path.abspath('./sql/schema/stat_buy_togethers.sql')
with open(sql_path, 'r', encoding='utf-8') as f:
    sqls = f.read()

# Execute DDL
create_table(sqls, conn, cursor)

# %%
# Insert `rules` to DB
insert_df_to_db(rules, 'stat_buy_togethers', conn, cursor)

# %%
# Close connection
conn.close()
print("Connection Closed!")


