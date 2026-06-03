# boto3・json・osを使う宣言
# boto3=AWSのSES・SNSを操作するため
import boto3
# SQSから受け取りデータを変換するため
import json
# 環境変数を取得するため
import os

# Lambdaのハンドラー関数(SQSからイベントが来たらこの関数を実行)
# event=SQSから受け取ったデータ
# context=Lambda実行環境の情報
def handler(event, context):
    """
    SQSからイベントを受け取り
    メール・Slack通知を送る
    """

    # SQSのメッセージを1件ずつ処理
    # event['Recoeds]=SQSから来たメッセージの一覧
    # json.loads=JSON文字列をPythonに変換
    # Print=ログに出力
    for record in event['Records']:
        body = json.loads(record['body'])
        print(f"通知送信: {body}")
    
    #正常な処理完了を返す
    return {"statusCode": 200}
