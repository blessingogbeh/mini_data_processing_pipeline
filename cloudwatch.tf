
# CloudWatch Metrics and Insights Dashboard
resource "aws_cloudwatch_dashboard" "insights_dashboard" {
  dashboard_name = "insights_dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
          ["AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", "${aws_dynamodb_table.insights_table.name}"]
          ]
          title   = "Data Pipeline Insights",
          view    = "timeSeries",
          stacked = false,
          region = "us-east-1"
        }
      }
    ]
  })
}

