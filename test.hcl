target "default" {
  context = "."
  dockerfile = "Dockerfile"
  tags = ["docker-registry.bo.local:5000/bo/base-common:latest"]
  platforms = ["linux/amd64", "linux/arm64"]
}
