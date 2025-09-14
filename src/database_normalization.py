# %% [markdown]
# # Set up & Load data

# %%
# Import Nessessary Libraries
import pandas as pd
pd.set_option("display.max_rows", None, "display.max_columns", None)
pd.set_option("display.max_colwidth", None)
import os
from db_connection.db_utils import get_connection, read_data, create_table, insert_df_to_db
from db_connection.connectors.mysql_aws_mba_and_dashboard import SERVER, PORT, DATABASE, USERNAME, PASSWORD
import utils.general as ug

# %%
# Connect to DB
conn, cursor = get_connection(SERVER, PORT, DATABASE, USERNAME, PASSWORD)

# %%
# Load Data
df = pd.read_csv("./data/raw/mba.csv")

# Select needed columns & Rename columns & Re-arrange columns
df = df[['Nhà sản xuất', 'Khách hàng', 'Email khách hàng', 'Ngày', 'Nguồn lưu lượng (Traffic)', 'UTM_source', 'Chi nhánh', 'Loại sản phẩm', 'Tỉnh thành', 'Đơn hàng', 'Sản phẩm', 'Quận huyện vận chuyển', 'Phiên bản', 'T.trạng t.toán', 'T.trạng đ.hàng', 'Phương thức thanh toán', 'Doanh thu', 'Tiền khuyến mãi', 'Doanh thu thuần', 'Tổng hóa đơn', 'Đã thu', 'Số lượng', 'Vận chuyển']]
df.columns = ['manufacturer', 'customer_name', 'email', 'order_date', 'traffic_source', 'utm_source', 'warehouse', 'category_name', 'province', 'order_id', 'product_name', 'district', 'product_type', 'payment_status', 'order_status', 'payment_method', 'amount', 'discount', 'net_amount', 'final_amount', 'received_amount', 'quantity', 'delivery_amount']
df = df[['manufacturer', 'customer_name', 'email', 'order_id', 'order_date', 'product_name', 'product_type', 'category_name', 'quantity', 'amount', 'discount', 'net_amount', 'delivery_amount', 'final_amount', 'received_amount', 'traffic_source', 'utm_source', 'warehouse', 'province', 'district', 'payment_status', 'order_status', 'payment_method']]

# %%
# Data Exploration
print('=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> .info()\n',df.info())
print('=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> .head()\n',df.head())
print('=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> .describe()\n',df.describe())
print('=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> .columns()\n',df.columns)
# Check Duplicated Rows => not found any duplicated rows
print('=>>>>>>>> DF\n',df[df.duplicated()])
# Check Duplicated Order ID => found some duplicated order id
print('=>>>>>>>> Check `order_id`\n', df[df.order_id.duplicated()].head())

# %% [markdown]
# # Processing Data

# %%
# Remove Duplicates: Remove duplicated (`order_id`, `product_name`) with amount = 0 (keep all duplicated rows with amount != 0) according to business requirement.
df=df[df.duplicated(subset=['order_id', 'product_name'], keep=False) & (df.amount != 0)]

# %% [markdown]
# ## Cleaning each fields

# %%
# Pre-processing: `manufacturer`
df['manufacturer'] = df['manufacturer'].apply(lambda x: ug.clean_text_field(x, convention='title'))

# %%
# Pre-processing: `customer_name`
df['customer_name'] = df['customer_name'].apply(lambda x: ug.clean_text_field(x, convention='title'))

# %%
# Pre-processing: `email`
df['email'] = df['email'].apply(lambda x: ug.clean_text_field(x)) # Clean text field
df['email'] = df['email'].apply(lambda x: ug.handle_invalid_email(x)) # Handle invalid email

# %%
# Pre-processing: `order_date`
df['order_date'] = pd.to_datetime(df['order_date'], format='%d/%m/%Y') # Convert to datetime

# %%
# Pre-processing: `category_name`
df['category_name'] = df['category_name'].apply(lambda x: ug.clean_text_field(x, convention='capitalize')) # Clean text field

# %%
# Pre-processing: `product_name`
df['product_name'] = df['product_name'].apply(lambda x: ug.clean_text_field(x)) # Clean text field
df['product_name'] = df['product_name'].apply(lambda x: ug.mapping_text(x, ug.mapping_text_dict, remove_special_tail='-')) # Mapping giá trị cột 'product_name' theo ug.ug.mapping_text_dict

# %%
# Pre-processing: `product_type`
df['product_type'] = df['product_type'].apply(lambda x: ug.clean_text_field(x)) # Clean text field

# %%
# Pre-processing: `traffic_source`
df['traffic_source'] = df['traffic_source'].apply(lambda x: ug.clean_text_field(x))
# Mapping giá trị cột 'traffic_source' theo ug.ug.mapping_text_dict
df['traffic_source'] = df['traffic_source'].apply(lambda x: ug.mapping_text(x, ug.mapping_text_dict))

# %%
# Pre-processing: `utm_source`
df['utm_source'] = df['utm_source'].apply(lambda x: ug.clean_text_field(x)) # Clean text field
df['utm_source'] = df['utm_source'].apply(lambda x: ug.mapping_text(x, ug.mapping_text_dict, remove_special_tail='-', convention='lower'))

# %%
# Pre-processing: `warehouse`
df['warehouse'] = df['warehouse'].apply(lambda x: ug.clean_text_field(x)) # Clean text field

# %%
# Pre-processing: `province`
df['province'] = df['province'].apply(lambda x: ug.clean_text_field(x)) # Clean text field

# %%
# Pre-processing: `district`
df['district'] = df['district'].apply(lambda x: ug.clean_text_field(x)) # Clean text field

# %%
# Pre-processing: `payment_status`
df['payment_status'] = df['payment_status'].apply(lambda x: ug.clean_text_field(x)) # Clean text field

# %%
# Pre-processing: `order_status`
df['order_status'] = df['order_status'].apply(lambda x: ug.clean_text_field(x)) # Clean text field

# %%
# Pre-processing: `payment_method`
df['payment_method'] = df['payment_method'].apply(lambda x: ug.clean_text_field(x)) # Clean text field

# %% [markdown]
# ## Convert data source's schema to Dimensional Schema

# %%
# Dimensional: `customers`
# Identify customer by their email -> Generate `customer_id``
customers_df = df[['email','customer_name']].sort_values(by=['email']).drop_duplicates(subset=(['email'])).reset_index(drop=True)
customers_df['id'] = customers_df.index + 1
# Rename columns
customers_df.columns = ['email', 'customer_name', 'customer_id']
# Re-arrange columns
customers_df = customers_df[['customer_id', 'customer_name', 'email']]

# %%
# Dimensional: `manufacturers`
# Identify manufacturer by their email -> Generate `manufacturer_id``
manufacturers_df = df[['manufacturer']].sort_values(by=['manufacturer']).drop_duplicates().reset_index(drop=True)
manufacturers_df['id'] = manufacturers_df.index + 1
# Rename columns
manufacturers_df.columns = ['manufacturer_name', 'manufacturer_id']
# Re-arrange columns
manufacturers_df = manufacturers_df[['manufacturer_id', 'manufacturer_name']]

# %%
# Dimensional: `categories`
categories_df = df[['category_name']].sort_values(by=['category_name']).drop_duplicates().reset_index(drop=True)
categories_df['id'] = categories_df.index + 1
# Rename columns
categories_df.columns = ['category_name', 'category_id']
# Re-arrange columns
categories_df = categories_df[['category_id', 'category_name']]

# %%
# Dimensional: `products`
products_df = df[['product_name']].sort_values(by=['product_name']).drop_duplicates().reset_index(drop=True)
products_df['id'] = products_df.index + 1
# Rename columns
products_df.columns = ['product_name', 'product_id']
# Select and Re-arrange columns
products_df = products_df[['product_id', 'product_name']]

# Mark gifted products
products_df['is_gift'] = (
    products_df['product_name'].str.lower().str.startswith('[gift]') |
    products_df['product_name'].str.lower().str.startswith('[quà tặng]')
).astype(int)

# %%
# Dimensional: `categories_products`
categories_products_df = df[['product_name', 'category_name']].sort_values(by=['product_name', 'category_name']).drop_duplicates().reset_index(drop=True)

categories_products_df['id'] = categories_products_df.index + 1
# Convert `product_name` into `product_id`
categories_products_df = categories_products_df.merge(products_df[['product_id', 'product_name']], on='product_name', how='left')
# Convert `category_name` into `category_id`
categories_products_df = categories_products_df.merge(categories_df, on='category_name', how='left')
# Rename columns
categories_products_df.columns = ['product_name', 'category_name', 'id', 'product_id', 'category_id']

# Select and Re-arrange columns
categories_products_df = categories_products_df[['id', 'product_id', 'category_id']]

# %%
# Dimensional: `skus`
skus_df = df[['product_name', 'product_type']].sort_values(by=['product_name', 'product_type']).drop_duplicates().reset_index(drop=True)
skus_df['id'] = skus_df.index + 1

skus_df = skus_df.merge(products_df, on='product_name', how='left') # Map `product_name' to 'product_id'
skus_df['sku_description'] = skus_df['product_name'] + ' | ' + skus_df['product_type']

# # Rename columns
skus_df.columns = ['product_name', 'product_type', 'sku_id', 'product_id', 'is_gift', 'sku_description']
# # Select and Re-arrange columns
skus_df = skus_df[['sku_id', 'product_id', 'sku_description', 'is_gift', 'product_name', 'product_type']]

# %%
# Dimensional: `payment_methods`
payment_methods_df = df[['payment_method']].sort_values(by=['payment_method']).drop_duplicates().reset_index(drop=True)
payment_methods_df['id'] = payment_methods_df.index + 1
# Rename columns
payment_methods_df.columns = ['description', 'payment_method']
# Re-arrange columns
payment_methods_df = payment_methods_df[['payment_method', 'description']]

# %%
# Dimensional: `payment_status`
payment_status_df = df[['payment_status']].sort_values(by=['payment_status']).drop_duplicates().reset_index(drop=True)
payment_status_df['id'] = payment_status_df.index + 1
# Rename columns
payment_status_df.columns = ['description', 'payment_status']
# Re-arrange columns
payment_status_df = payment_status_df[['payment_status', 'description']]

# %%
# Dimensional: `order_status`
order_status_df = df[['order_status']].sort_values(by=['order_status']).drop_duplicates().reset_index(drop=True)
order_status_df['id'] = order_status_df.index + 1
# Rename columns
order_status_df.columns = ['description', 'order_status']
# Re-arrange columns
order_status_df = order_status_df[['order_status', 'description']]

# %%
# Dimensional: `warehouses`
warehouses_df = df[['warehouse']].sort_values(by=['warehouse']).drop_duplicates().reset_index(drop=True)
warehouses_df['id'] = warehouses_df.index + 1
# Rename columns
warehouses_df.columns = ['warehouse_name', 'warehouse_id']
# Re-arrange columns
warehouses_df = warehouses_df[['warehouse_id', 'warehouse_name']]

# %%
# Dimensional: `provinces`
provinces_df = df[['province']].sort_values(by=['province']).drop_duplicates().reset_index(drop=True)
provinces_df['id'] = provinces_df.index + 1
# Rename columns
provinces_df.columns = ['province_name', 'province_id']
# Re-arrange columns
provinces_df = provinces_df[['province_id', 'province_name']]

# %%
# Dimensional: `districts`
districts_df = df[['province', 'district']].sort_values(by=['province', 'district']).drop_duplicates().reset_index(drop=True)
districts_df['id'] = districts_df.index + 1
districts_df = districts_df.merge(provinces_df, left_on='province', right_on='province_name', how='left') # Map `province_name' to 'province_id'
# Rename columns
districts_df.columns = ['province', 'district_name', 'district_id', 'province_id', 'province_name']
# Select & Re-arrange columns
districts_df = districts_df[['district_id', 'district_name', 'province_id']]

# %%
# Fact Table: `sale_details_df`
# Map `field_name` to `field_id`

sale_details_df = df
        
# Map `email` to `customer_id`
sale_details_df = sale_details_df.merge(customers_df[['email', 'customer_id']], on='email', how='left')

# Map (`product_name`,`product_type`) to `sku_id`
sale_details_df = sale_details_df.merge(skus_df[['sku_id', 'product_name', 'product_type']], on=['product_name', 'product_type'], how='left')

# Map `product_name` to `product_id`
sale_details_df = sale_details_df.merge(products_df[['product_id', 'product_name']], on='product_name', how='left')

# Map `category_name` to `category_id`
sale_details_df = sale_details_df.merge(categories_df, on='category_name', how='left')

# Map `manufacturer` to `manufacturer_id`
sale_details_df = sale_details_df.merge(manufacturers_df, left_on='manufacturer', right_on='manufacturer_name', how='left')

# Map `warehouse` to `warehouse_id`
sale_details_df = sale_details_df.merge(warehouses_df, left_on='warehouse', right_on='warehouse_name', how='left')

# Map `payment_method(description)` to `payment_method(id)``
sale_details_df = sale_details_df.merge(payment_methods_df, left_on='payment_method', right_on='description', how='left')

# Map `payment_status(description)` to `payment_status(id)`
sale_details_df = sale_details_df.merge(payment_status_df, left_on='payment_status', right_on='description', how='left')

# Map `order_status(description)` to `order_status(id)`
sale_details_df = sale_details_df.merge(order_status_df, left_on='order_status', right_on='description', how='left')

# Map `province` to `province_id`
sale_details_df = sale_details_df.merge(provinces_df, left_on='province', right_on='province_name', how='left')

# Map `district` to `district_id` (need to map `province_id` first to get `province_id` for mapping `district_id`)
sale_details_df = sale_details_df.merge(districts_df, left_on=['district', 'province_id'], right_on=['district_name', 'province_id'], how='left')

# Generate `id` for `sale_details_df`
sale_details_df['id'] = sale_details_df.index + 1

# Select &  Re-arrange columns
sale_details_df = sale_details_df[['id', 'order_id', 'order_date', 'customer_id', 'sku_id', 'product_id', 'category_id', 'manufacturer_id','warehouse_id', 'payment_method_y', 'payment_status_y','order_status_y', 'district_id', 'province_id', 'quantity', 'amount', 'discount', 'net_amount', 'delivery_amount', 'final_amount', 'received_amount', 'traffic_source', 'utm_source']].reset_index(drop=True)

# Rename columns
sale_details_df.columns = ['id', 'order_id', 'order_date', 'customer_id', 'sku_id', 'product_id', 'category_id', 'manufacturer_id','warehouse_id', 'payment_method', 'payment_status','order_status', 'delivery_district_id', 'delivery_province_id', 'quantity', 'amount', 'discount', 'net_amount', 'delivery_amount', 'final_amount', 'received_amount', 'traffic_source', 'utm_source']

# %% [markdown]
# # Load Data to DB

# %%
# Create Table
# Get DDL
sql_path = os.path.abspath('./sql/schema/database_normalization.sql')
with open(sql_path, 'r', encoding='utf-8') as f:
    sqls = f.read()

# Execute DDL
create_table(sqls, conn, cursor)

# %%
# Insert lần lượt các bảng dimension và fact
insert_df_to_db(customers_df, 'dim_customers', conn, cursor)
insert_df_to_db(manufacturers_df, 'dim_manufacturers', conn, cursor)
insert_df_to_db(categories_df, 'dim_categories', conn, cursor)
insert_df_to_db(products_df, 'dim_products', conn, cursor)
insert_df_to_db(categories_products_df, 'bridge_categories_products', conn, cursor)
insert_df_to_db(skus_df, 'dim_skus', conn, cursor)
insert_df_to_db(payment_methods_df, 'dim_payment_methods', conn, cursor)
insert_df_to_db(payment_status_df, 'dim_payment_status', conn, cursor)
insert_df_to_db(order_status_df, 'dim_order_status', conn, cursor)
insert_df_to_db(warehouses_df, 'dim_warehouses', conn, cursor)
insert_df_to_db(provinces_df, 'dim_provinces', conn, cursor)
insert_df_to_db(districts_df, 'dim_districts', conn, cursor)
insert_df_to_db(sale_details_df, 'fact_sale_details', conn, cursor)

# %%
# Đóng connection
conn.close()
print("Connection Closed!")