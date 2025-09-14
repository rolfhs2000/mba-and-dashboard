import pandas as pd
from mlxtend.frequent_patterns import fpgrowth, association_rules
from mlxtend.preprocessing import TransactionEncoder

def prepare_data(df, item_col, trans_col):
    """Chuyển đổi dữ liệu về dạng one-hot cho FP-Growth."""
    basket = df.groupby('order_id')['sku_description'].apply(list).tolist()
    # Mã hóa dữ liệu đơn hàng
    te = TransactionEncoder()
    te_ary = te.fit(basket).transform(basket)
    basket = pd.DataFrame(te_ary, columns=te.columns_)
    # basket = df.groupby([trans_col, item_col]).size().unstack(fill_value=0)
    # basket = basket.applymap(lambda x: 1 if x > 0 else 0)
    return basket

def run_fp_growth(basket, min_support=0.01):
    """Chạy FP-Growth để tìm itemsets phổ biến."""
    freq_itemsets = fpgrowth(basket, min_support=min_support, use_colnames=True)
    return freq_itemsets

def get_association_rules(freq_itemsets, metric="confidence", min_threshold=0.2):
    """Tính các luật kết hợp từ itemsets."""
    rules = association_rules(freq_itemsets, metric=metric, min_threshold=min_threshold)

    # Filter `confidence` = 1 (due to that maybe combo products)
    rules = rules[rules.confidence!=1]
    # Filter `lift` >= 1
    rules = rules[rules.lift>=1]

    # Rename column
    rules = rules[['antecedents', 'consequents', 'antecedent support', 'consequent support', 'support', 'confidence', 'lift']].sort_values(by=(['confidence', 'support', 'lift']), ascending=False)
    rules.columns = ['antecedents', 'consequents', 'antecedent_support', 'consequent_support', 'support', 'confidence', 'lift']

    return rules
