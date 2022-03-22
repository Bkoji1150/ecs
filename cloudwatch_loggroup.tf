# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "testapp_log_group" {
  name              = "/ecs/testapp"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "myapp_log_stream" {
  name           = "test-log-stream"
  log_group_name = aws_cloudwatch_log_group.testapp_log_group.name
}

resource "aws_cloudwatch_metric_alarm" "container_cpu" {
  alarm_name          = lower(format("%s-%s-CPU-utilization-greater-than-90", local.cluster_name, var.component_name))
  alarm_description   = "Alarm if cpu utilization greater than 90%"
  namespace           = "AWS/ECS"
  metric_name         = "CPUUtilization"
  statistic           = "Maximum"
  period              = "60"
  evaluation_periods  = "3"
  threshold           = "90"
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    cluster_name = local.cluster_name
    service_name = local.cfqn_name
  }
}

resource "aws_cloudwatch_metric_alarm" "container_cpu_reservation" {
  alarm_name          = lower(format("%s-%s-CPU-reservation-greater-than-90", local.cluster_name, var.component_name))
  alarm_description   = "Alarm if cpu reservation greater than 90%"
  namespace           = "AWS/ECS"
  metric_name         = "CPUReservation"
  statistic           = "Maximum"
  period              = "60"
  evaluation_periods  = "3"
  threshold           = "90"
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    cluster_name = local.cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "container_memory_utilization" {
  alarm_name          = lower(format("%s-%s-Memory-utilization-greater-than-95", local.cluster_name, var.component_name))
  alarm_description   = "Alarm if memory utilization greater than 95%"
  namespace           = "AWS/ECS"
  metric_name         = "instance_memory_utliization"
  statistic           = "Maximum"
  period              = "60"
  evaluation_periods  = "3"
  threshold           = "95"
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    cluster_name = local.cluster_name
    service_name = local.cfqn_name
  }
}

resource "aws_cloudwatch_metric_alarm" "container_memory_reservation" {
  alarm_name          = lower(format("%s-%s-Memory-reservation-greater-than-95", local.cluster_name, var.component_name))
  alarm_description   = "Alarm if memory reservation greater than 95%"
  namespace           = "AWS/ECS"
  metric_name         = "MemoryReservation"
  statistic           = "Maximum"
  period              = "60"
  evaluation_periods  = "3"
  threshold           = "95"
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    cluster_name = local.cluster_name
  }
}
