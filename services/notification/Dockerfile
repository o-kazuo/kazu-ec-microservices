# AWS Labmda用のPython3.11環境
FROM public.ecr.aws/lambda/python:3.11
# /appを作業場所に指定
WORKDIR /app
# ライブラリのインストール実行(今回はboto3のみでPythonからAWSを操作するライブラリ)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
# イベントが来たらmain.pyのhandler関数を実行
CMD ["main.handler"]
