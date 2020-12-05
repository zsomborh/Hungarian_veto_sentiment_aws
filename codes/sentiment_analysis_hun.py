from typing import Any, Union
import pandas as pd

df = pd.read_csv("data/clean/sentiment_analised.csv")

for col in df.columns:
    print(col)