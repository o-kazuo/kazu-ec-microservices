# FastAPIを使うという宣言
from fastapi import FastAPI

# FastAPIのアプリを作成
app = FastAPI()

# /healthにアクセスして、ECSが生きている場合、{"Status": "healthy"}を返す設定
@app.get("/health")
def health_check():
    return {"status": "healthy"}

# /productsにアクセスしたら商品一覧を返す
@app.get("/products")
def get_products():
    return [
        {"id": 1, "name": "商品A", "price": 1000},
        {"id": 2, "name": "商品B", "price": 2000},
    ]

