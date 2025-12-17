variable "IMAGE_REPO" {
  default = "easyteleop"
}

variable "TAG" {
  default = "latest"
}

variable "NEXT_PUBLIC_API_URL" {
  default = "/api"
}

variable "NEXT_PUBLIC_MQTT_URL" {
  default = ""
}

variable "NEXT_PUBLIC_MQTT_USERNAME" {
  default = "admin"
}

variable "NEXT_PUBLIC_MQTT_PASSWORD" {
  default = "public"
}

group "default" {
  targets = ["backend", "node", "frontend", "hdf5"]
}

target "_common" {
  pull = true
}

target "backend" {
  inherits   = ["_common"]
  context    = "./EasyTeleop-Backend-Python"
  dockerfile = "Dockerfile"
  tags       = ["${IMAGE_REPO}/backend:${TAG}"]
}

target "node" {
  inherits   = ["_common"]
  context    = "./EasyTeleop-Node"
  dockerfile = "Dockerfile"
  tags       = ["${IMAGE_REPO}/node:${TAG}"]
}

target "frontend" {
  inherits   = ["_common"]
  context    = "./EasyTeleopFrontend"
  dockerfile = "Dockerfile"
  args = {
    NEXT_PUBLIC_API_URL      = "${NEXT_PUBLIC_API_URL}"
    NEXT_PUBLIC_MQTT_URL     = "${NEXT_PUBLIC_MQTT_URL}"
    NEXT_PUBLIC_MQTT_USERNAME = "${NEXT_PUBLIC_MQTT_USERNAME}"
    NEXT_PUBLIC_MQTT_PASSWORD = "${NEXT_PUBLIC_MQTT_PASSWORD}"
  }
  tags = ["${IMAGE_REPO}/frontend:${TAG}"]
}

target "hdf5" {
  inherits   = ["_common"]
  context    = "./HDF5DataVisualize"
  dockerfile = "Dockerfile"
  tags       = ["${IMAGE_REPO}/hdf5:${TAG}"]
}

target "_multiarch" {
  platforms = ["linux/amd64", "linux/arm64"]
}

target "backend_multi" {
  inherits = ["backend", "_multiarch"]
}

target "node_multi" {
  inherits = ["node", "_multiarch"]
}

target "frontend_multi" {
  inherits = ["frontend", "_multiarch"]
}

target "hdf5_multi" {
  inherits = ["hdf5", "_multiarch"]
}

group "multi" {
  targets = ["backend_multi", "node_multi", "frontend_multi", "hdf5_multi"]
}

target "_amd64" {
  platforms = ["linux/amd64"]
}

target "backend_amd64" {
  inherits = ["backend", "_amd64"]
  tags     = ["${IMAGE_REPO}/backend:${TAG}-amd64"]
}

target "node_amd64" {
  inherits = ["node", "_amd64"]
  tags     = ["${IMAGE_REPO}/node:${TAG}-amd64"]
}

target "frontend_amd64" {
  inherits = ["frontend", "_amd64"]
  tags     = ["${IMAGE_REPO}/frontend:${TAG}-amd64"]
}

target "hdf5_amd64" {
  inherits = ["hdf5", "_amd64"]
  tags     = ["${IMAGE_REPO}/hdf5:${TAG}-amd64"]
}

group "tar_amd64" {
  targets = ["backend_amd64", "node_amd64", "frontend_amd64", "hdf5_amd64"]
}

target "_arm64" {
  platforms = ["linux/arm64"]
}

target "backend_arm64" {
  inherits = ["backend", "_arm64"]
  tags     = ["${IMAGE_REPO}/backend:${TAG}-arm64"]
}

target "node_arm64" {
  inherits = ["node", "_arm64"]
  tags     = ["${IMAGE_REPO}/node:${TAG}-arm64"]
}

target "frontend_arm64" {
  inherits = ["frontend", "_arm64"]
  tags     = ["${IMAGE_REPO}/frontend:${TAG}-arm64"]
}

target "hdf5_arm64" {
  inherits = ["hdf5", "_arm64"]
  tags     = ["${IMAGE_REPO}/hdf5:${TAG}-arm64"]
}

group "tar_arm64" {
  targets = ["backend_arm64", "node_arm64", "frontend_arm64", "hdf5_arm64"]
}
