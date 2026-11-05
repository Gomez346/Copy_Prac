
# Recurso para instancia OCI Compute
resource "oci_core_instance" "ubuntu-vm" {
  compartment_id      = var.compartment_ocid
  display_name        = "ubuntu-web-estatica"
  availability_domain = var.availability_domain
  shape               = "VM.Standard.E2.1.Micro"

  source_details {
    source_type = "image"
    source_id   = var.ubuntu_image_ocid
  }

  create_vnic_details {
    subnet_id        = var.subnet_ocid
    assign_public_ip = true
    display_name     = "ubuntu-vm-vnic"
    hostname_label   = "ubuntu-web-estatica"
  }

  # Metadatos: Llave SSH y script de aprovisionamiento modularizado
  metadata = {
    "ssh_authorized_keys" = var.ssh_public_key_path
    "user_data"           = base64encode(file("${path.module}/script.sh"))
  }
}

output "public_ip" {
  value       = oci_core_instance.ubuntu-vm.public_ip
  description = "IP PUBLICA de servidor web"
}
