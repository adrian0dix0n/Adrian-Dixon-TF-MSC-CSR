
module "test-vpc-module" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 6.0"
  project_id   = var.project_id # Replace this with your project ID
  network_name = var.network_name
  mtu          = 1460
  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-east1"
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-east1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name               = "subnet-03"
      subnet_ip                 = "10.10.30.0/24"
      subnet_region             = "us-east1"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_filter   = "false"
    }
  ]
}

module "test-vpc-module-2" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 6.0"
  project_id   = "nonprod2-svc-b6s8"
  network_name = "tf-example-vpc-2"
  mtu          = 1460
  subnets = [
    {
      subnet_name   = "subnet-04"
      subnet_ip     = "11.11.11.0/24"
      subnet_region = "us-east1"
    },
    {
      subnet_name           = "subnet-05"
      subnet_ip             = "11.11.22.0/24"
      subnet_region         = "us-east1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name               = "subnet-06"
      subnet_ip                 = "11.11.33.0/24"
      subnet_region             = "us-east1"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_filter   = "false"
    }
  ]
}

resource "google_compute_instance_template" "instance_template_tfvpc1" {
  name         = "tf-msc-example-1"
  machine_type = "e2-medium"
  region       = "us-east1"

  metadata_startup_script = <<-EOF
    #!/bin/bash
    # Install Jenkins here
    apt-get update
    apt-get install -y openjdk-11-jdk
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    apt-get update
    apt-get install -y jenkins
  EOF

  disk {
    source_image = "projects/nonprod1-svc-b6s8/global/images/adrian-dixon-image-test-tf-msc"
    auto_delete  = true
    boot         = true
  }
  network_interface {
    network    = "tf-example-vpc-1"
    subnetwork = "subnet-03"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "instance-group-manager-tf1" {
  name = "td-adixon-tfmsc-igm1"
  version {
    name              = "instance-template-1"
    instance_template = google_compute_instance_template.instance_template_tfvpc1.self_link_unique
  }
  base_instance_name = "test-igm-1"
  zone               = "us-east1-b"
  target_size        = 2
}

resource "google_compute_instance_template" "instance_template_tfvpc2" {
  name         = "tf-msc-example-2"
  machine_type = "e2-medium"
  region       = "us-east1"

  metadata_startup_script = <<-EOF
    #!/bin/bash
    # Install Jenkins here
    apt-get update
    apt-get install -y openjdk-11-jdk
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    apt-get update
    apt-get install -y jenkins
  EOF

  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
  }
  network_interface {
    network    = "tf-example-vpc-2"
    subnetwork = "subnet-06"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "instance-group-manager-tf2" {
  name = "td-adixon-tfmsc-igm2"
  version {
    name              = "instance-template-2"
    instance_template = google_compute_instance_template.instance_template_tfvpc2.self_link_unique
  }
  base_instance_name = "test-igm-2"
  zone               = "us-east1-b"
  target_size        = 2
}