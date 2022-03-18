locals {
  default_tags = {
    Env               = lower(terraform.workspace)
    service_name      = "reporting"
    cell_name         = "reporting-frontend"
    component_name    = "aws-eksnginx"
    service_tier      = "WEB"
    builder           = "hqr-devops@bellese.io"
    application_owner = "hqr-feedback-and-support-product@bellese.io"
  }
  cluster_name = var.cluster_name == null ? upper(format("HQR-%s-HOST", var.tier)) : var.cluster_name
  cfqn_name    = format("%s-%s", var.cell_name, var.component_name)
}
