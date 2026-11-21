from itertools import combinations
import pandas as pd

def make_basket_matrix(df, transaction_col="transaction_id", item_col="product_name"):
    matrix = pd.crosstab(df[transaction_col], df[item_col]).gt(0).astype(int)
    return matrix

def apriori(binary_df, min_support=0.03, max_len=3):
    n = len(binary_df)
    if n == 0:
        raise ValueError("Brak transakcji.")
    items = list(binary_df.columns)
    out=[]
    for length in range(1, max_len+1):
        for combo in combinations(items, length):
            support = float(binary_df[list(combo)].all(axis=1).mean())
            if support >= min_support:
                out.append({"support": support, "itemsets": frozenset(combo)})
    result = pd.DataFrame(out)
    if not result.empty:
        result = result.sort_values(["support"], ascending=False).reset_index(drop=True)
    return result

def association_rules(frequent_itemsets, metric="confidence", min_threshold=0.3):
    support_map = {frozenset(r.itemsets): float(r.support) for r in frequent_itemsets.itertuples()}
    rules=[]
    for itemset, sup_xy in support_map.items():
        if len(itemset) < 2:
            continue
        items=list(itemset)
        for r in range(1,len(items)):
            for ant_tuple in combinations(items,r):
                ant=frozenset(ant_tuple)
                cons=itemset-ant
                sup_x=support_map.get(ant)
                sup_y=support_map.get(cons)
                if not sup_x or not sup_y:
                    continue
                confidence=sup_xy/sup_x
                lift=confidence/sup_y
                leverage=sup_xy-sup_x*sup_y
                conviction=(1-sup_y)/(1-confidence) if confidence < 1 else float('inf')
                row={"antecedents":ant,"consequents":cons,"antecedent support":sup_x,"consequent support":sup_y,
                     "support":sup_xy,"confidence":confidence,"lift":lift,"leverage":leverage,"conviction":conviction}
                if row.get(metric,0) >= min_threshold:
                    rules.append(row)
    df=pd.DataFrame(rules)
    if not df.empty:
        df=df.sort_values(["lift","confidence","support"],ascending=[False,False,False]).reset_index(drop=True)
    return df

def pretty_set(value):
    return ", ".join(sorted(value))
