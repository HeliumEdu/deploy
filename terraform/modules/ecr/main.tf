resource "aws_ecrpublic_repository" "repository_helium_frontend" {
  repository_name = "helium/frontend"
}

resource "aws_ecrpublic_repository" "repository_helium_platform_resource" {
  repository_name = "helium/platform"
}

resource "aws_ecrpublic_repository" "repository_helium_platform_api" {
  repository_name = "helium/platform-api"
}

resource "aws_ecrpublic_repository" "repository_helium_platform_worker" {
  repository_name = "helium/platform-worker"
}