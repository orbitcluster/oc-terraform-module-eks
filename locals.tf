locals{
    cloudinit_post_nodeadm = [
      {
        content_type = "application/node.eks.aws"
        content =  <<-EOT
        ---
        apiVersion: node.eks.aws/v1alpha1
        kind: NodeConfig
        spec:
            kubelet: ${var.max_pods_per_node != null ? "\n config:\n  maxPods: ${var.max_pods_per_node}" : ""}
             flags:
                - "--node-labels=node.kubernetes.io/instance-type=${var.node_instance_type}, environment=${var.env}"
        EOT
      }
    ]
}
