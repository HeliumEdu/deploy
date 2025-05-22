locals {
  about_text = "Helium is an online student planner that lets you organize and color-coordinate your schedule and schoolwork, capture details about every assignment, and plan your study time efficiently."
  platform_usage_text = "Helium is open source, and usage details for this image be found at https://github.com/heliumedu/platform."
}

resource "aws_ecrpublic_repository" "repository_helium_frontend" {
  repository_name = "helium/frontend"

  catalog_data {
    operating_systems = ["Linux"]
    architectures = ["x86-64"]
    logo_image_blob = filebase64("${path.module}/../../resources/logo.png")
    description = "Frontend images for https://www.heliumedu.com"
    about_text = local.about_text
    usage_text = "HeliumEdu is open source, and usage details for this image be found at https://github.com/heliumedu/frontend."
  }

  tags = {
    Environment = "N/A"
    Service     = "HeliumEdu"
  }
}

resource "aws_ecrpublic_repository" "repository_helium_platform_resource" {
  repository_name = "helium/platform-resource"

  catalog_data {
    operating_systems = ["Linux"]
    architectures = ["x86-64"]
    logo_image_blob = filebase64("${path.module}/../../resources/logo.png")
    description = "Base platform images for https://www.heliumedu.com"
    about_text = local.about_text
    usage_text = local.platform_usage_text
  }

  tags = {
    Environment = "N/A"
    Service   = "HeliumEdu"
  }
}

resource "aws_ecrpublic_repository" "repository_helium_platform_api" {
  repository_name = "helium/platform-api"

  catalog_data {
    operating_systems = ["Linux"]
    architectures = ["x86-64"]
    logo_image_blob = filebase64("${path.module}/../../resources/logo.png")
    description = "API platform images for https://www.heliumedu.com"
    about_text = local.about_text
    usage_text = local.platform_usage_text
  }

  tags = {
    Environment = "N/A"
    Service   = "HeliumEdu"
  }
}

resource "aws_ecrpublic_repository" "repository_helium_platform_worker" {
  repository_name = "helium/platform-worker"

  catalog_data {
    operating_systems = ["Linux"]
    architectures = ["x86-64"]
    logo_image_blob = filebase64("${path.module}/../../resources/logo.png")
    description = "Worker platform images for https://www.heliumedu.com"
    about_text = local.about_text
    usage_text = local.platform_usage_text
  }

  tags = {
    Environment = "N/A"
    Service   = "HeliumEdu"
  }
}