variable "pm_api_url" {
  type = string
}

variable "pm_api_token_id" {
  type      = string
  sensitive = true
}

variable "pm_api_token_secret" {
  type      = string
  sensitive = true
}

variable "target_node" {
  type = string
  # Kosongkan default-nya agar fleksibel
}

variable "container_count" {
  default = 3
}

variable "ssh_key_path" {
  description = "Lokasi file public key di komputer lokal"
  type        = string
  default     = "C:/Users/TiffanyLA/.ssh/id_rsa.pub"
}