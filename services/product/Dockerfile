# ベースイメージ（Python3.11を使う）
FROM python:3.11-slim

# 作業ディレクトリを作成
WORKDIR /app

# 必要なライブラリ一覧をコピー
COPY requirements.txt .

# ライブラリをインストール
RUN pip install --no-cache-dir -r requirements.txt

# FastAPIのコードをコピー
COPY . .

# ポート8000番を開放
EXPOSE 8000

# 起動コマンド
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
