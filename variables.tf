/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  description = "The project ID to host the network in"
  default     = "nonprod1-svc-b6s8"
}

variable "network_name" {
  description = "The name of the VPC network being created"
  default     = "tf-example-vpc-1"
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
  default     = "us-east1"
}

variable "subnetwork" {
  description = "The subnetwork to host the compute instances in"
  default     = "subnet-06"
}

variable "target_size" {
  description = "The target number of running instances for this managed instance group. This value should always be explicitly set unless this resource is attached to an autoscaler, in which case it should never be set."
  default     = "2"
}

variable "source_image" {
  description = "The image from which to initialize this disk."
  default     = "projects/nonprod2-svc-b6s8/global/images/adrian-dixon-image-test-tf-msc"
}