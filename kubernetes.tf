resource "kubernetes_namespace" "alexverboonen" {
  metadata {
    annotations = {
      name = "alex-verboonen"
    }
    labels = {
      mylabel = "label-value"
    }
    name = "alex-verboonen"
  }
}


resource "kubernetes_deployment" "example" {
  metadata {
    name = "demo-deployment"
    labels = {
      test = "demo"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        test = "demo"
      }
    }

    template {
      metadata {
        labels = {
          test = "demo"
        }
      }

      spec {
        container {
          image = "ghost:alpine"
          name  = "example"
        }
      }
    }
  }
}


resource "kubernetes_service" "mi-servicio" {
  metadata {
    name = "mi-servicio"
    namespace="alex-verboonen"
    labels = {
      test = "demo"
    }
  }
  spec {
    port{
      port = 80
      protocol = "TCP"
      target_port = 80
    }
}
}
