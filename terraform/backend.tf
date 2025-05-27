terraform {
  backend "gcs" {
    bucket = "ersms-460608-tf-state"
    prefix = "terraform/state"
  }
}
