output "queue_url" {
  description = "SQSキューのURL"
  value       = aws_sqs_queue.main.url
}

output "queue_arn" {
  description = "SQSキューのARN"
  value       = aws_sqs_queue.main.arn
}

output "dlq_arn" {
  description = "デッドレターキューのARN"
  value       = aws_sqs_queue.dlq.arn
}
