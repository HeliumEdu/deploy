data "http" "logo_img" {
  url = "https://www.heliumedu.com/assets/img/logo_full_blue.png"
}

resource "aws_ecrpublic_repository" "repository_helium_frontend" {
  repository_name = "helium/frontend"

  catalog_data {
    architectures = ["ARM 64"]
    description = "Frontend images for https://www.heliumedu.com"
    logo_image_blob = base64encode(data.http.logo_img.response_body)
    operating_systems = ["Linux"]
  }

  tags = {
    Service   = "HeliumEdu"
    Terraform = true
  }
}

resource "aws_ecrpublic_repository" "repository_helium_platform_resource" {
  repository_name = "helium/platform-resource"

  catalog_data {
    architectures = ["ARM 64"]
    description = "Base platform images for https://www.heliumedu.com"
    logo_image_blob = base64encode(data.http.logo_img.response_body)
    operating_systems = ["Linux"]
  }

  tags = {
    Service   = "HeliumEdu"
    Terraform = true
  }
}

resource "aws_ecrpublic_repository" "repository_helium_platform_api" {
  repository_name = "helium/platform-api"

  catalog_data {
    architectures = ["ARM 64"]
    description = "API platform images for https://www.heliumedu.com"
    logo_image_blob = base64encode(data.http.logo_img.response_body)
    operating_systems = ["Linux"]
  }

  tags = {
    Service   = "HeliumEdu"
    Terraform = true
  }
}

resource "aws_ecrpublic_repository" "repository_helium_platform_worker" {
  repository_name = "helium/platform-worker"

  catalog_data {
    architectures = ["ARM 64"]
    description = "Worker platform images for https://www.heliumedu.com"
    logo_image_blob = base64encode(data.http.logo_img.response_body)
    operating_systems = ["Linux"]
  }

  tags = {
    Service   = "HeliumEdu"
    Terraform = true
  }
}