locals {
  cluster_name = var.cluster_name == null ? upper(format("HQR-%s-HOST", var.tier)) : var.cluster_name
  cfqn_name    = format("%s-%s", var.cell_name, var.component_name)
}
