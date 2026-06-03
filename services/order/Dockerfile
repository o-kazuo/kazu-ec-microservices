# Python3.11が入った最小限(slim)のLinuxを用意する
# これがコンテナのOS+Python環境
FROM python:3.11-slim
# コンテナ内に/appフォルダを作成して作業場所にする
WORKDIR /app
# localのrequirements.txtをコンテナの/appのコピーしライブラリ一覧を入れる
COPY requirements.txt .
# requirements.txtに書いてあるライブラリを全部インストール
RUN pip install --no-cache-dir -r requirements.txt
# localの全ファイルコンテナの/appにコピー(main.pyが中に入る)
COPY . .
EXPOSE 8000
# コンテナが起動したらこのコマンドを実行
# FastAPIを動かくサーバー・main.pyのappを起動・どこからでもアクセスOK・8000番ポートで起動
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
