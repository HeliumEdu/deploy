# TODO: add provisioning for IAM roles

resource "aws_ecs_task_definition" "frontend_service" {
  family = "helium_frontend"
  container_definitions = jsonencode([
    {
      name      = "helium_frontend"
      image     = "562129510549.dkr.ecr.us-east-1.amazonaws.com/helium/frontend:${var.helium_version}"
      cpu       = 0
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
          app_protocol  = "http"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = "/ecs/helium"
          "mode" : "non-blocking"
          "awslogs-region" : var.aws_region
          "awslogs-stream-prefix" : "ecs/frontend"
        }
      }
    },
    {
      name      = "datadog-agent"
      image     = "public.ecr.aws/datadog/agent:latest"
      cpu       = 0
      essential = false
      environment = [
        {
          name  = "ECS_FARGATE"
          value = "true"
        },
        {
          name  = "DD_API_KEY"
          value = var.datadog_api_key
        }
      ]
    }
  ])

  cpu    = "256"
  memory = "512"

  task_role_arn      = "arn:aws:iam::${var.aws_account_id}:role/HeliumEduRole"
  execution_role_arn = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  network_mode       = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]

  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_task_definition" "platform_service" {
  family = "helium_platform_${var.environment}"
  container_definitions = jsonencode([
    {
      name      = "helium_platform_api"
      image     = "562129510549.dkr.ecr.us-east-1.amazonaws.com/helium/platform-api:${var.helium_version}"
      cpu       = 0
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
          app_protocol  = "http"
        }
      ]
      environment = [
        {
          name  = "ENVIRONMENT"
          value = var.environment
        },
        {
          name  = "USE_AWS_SECRETS_MANAGER"
          value = "True"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = "/ecs/helium"
          "mode" : "non-blocking"
          "awslogs-region" : var.aws_region
          "awslogs-stream-prefix" : "ecs-frontend"
        }
      }
    },
    {
      name      = "helium_platform_worker"
      image     = "562129510549.dkr.ecr.us-east-1.amazonaws.com/helium/platform-worker:${var.helium_version}"
      cpu       = 0
      essential = true
      environment = [
        {
          name  = "ENVIRONMENT"
          value = var.environment
        },
        {
          name  = "USE_AWS_SECRETS_MANAGER"
          value = "True"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = "/ecs/helium"
          "mode" : "non-blocking"
          "awslogs-region" : var.aws_region
          "awslogs-stream-prefix" : "ecs-worker"
        }
      }
    },
    {
      name      = "datadog-agent"
      image     = "public.ecr.aws/datadog/agent:latest"
      cpu       = 0
      essential = false
      environment = [
        {
          name  = "ECS_FARGATE"
          value = "true"
        },
        {
          name  = "DD_API_KEY"
          value = var.datadog_api_key
        }
      ]
    }
  ])

  cpu    = "2048"
  memory = "4096"

  task_role_arn      = "arn:aws:iam::${var.aws_account_id}:role/HeliumEduRole"
  execution_role_arn = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  network_mode       = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]

  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_cluster" "helium" {
  name = "helium"
}

resource "aws_ecs_cluster_capacity_providers" "helium" {
  cluster_name = aws_ecs_cluster.helium.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_service" "helium_frontend" {
  name                              = "helium_frontend"
  cluster                           = aws_ecs_cluster.helium.id
  task_definition                   = aws_ecs_task_definition.frontend_service.arn
  desired_count                     = 1
  health_check_grace_period_seconds = 10

  network_configuration {
    subnets = [for id in var.subnet_ids : id]
    security_groups = [var.http_frontend]
  }

  load_balancer {
    target_group_arn = var.frontend_target_group
    container_name   = "helium_frontend"
    container_port   = 3000
  }
}

resource "aws_ecs_service" "helium_platform" {
  name                              = "helium_platform"
  cluster                           = aws_ecs_cluster.helium.id
  task_definition                   = aws_ecs_task_definition.platform_service.arn
  desired_count                     = 2
  health_check_grace_period_seconds = 10

  network_configuration {
    subnets = [for id in var.subnet_ids : id]
    security_groups = [var.http_platform]
  }

  load_balancer {
    target_group_arn = var.platform_target_group
    container_name   = "helium_platform_api"
    container_port   = 8000
  }
}