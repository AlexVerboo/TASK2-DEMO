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


resource "kubernetes_deployment" "deploy" {
  metadata {
    name = "demo-deployment"
    namespace="alex-verboonen"
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
          name  = "deploy"
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
    selector = {
      app = "deploy"
    }
    type = "NodePort"
    port{
      port = 80
      protocol = "TCP"
      target_port = 80
    }
}
}
resource "kubernetes_ingress" "example_ingress" {
  metadata {
    name = "example-ingress"
    namespace="alex-verboonen"
  }

  spec {
    backend {
      service_name = "mi-servicio"
      service_port = 80
    }
    rule {
      http {
        path {
          backend {
            service_name = "mi-servicio"
            service_port = 80
          }
        }
      }
    }

    tls {
      secret_name = "tls-secret"
    }
  }
}


resource "kubernetes_cron_job" "demo" {
  metadata {
    name = "demo"
    namespace="alex-verboonen"
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 5
    schedule                      = "0 8 * * *"
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 10
    job_template {
      metadata {}
      spec {
        backoff_limit              = 2
        ttl_seconds_after_finished = 10
        template {
          metadata {}
          spec {
            container {
              name    = "hello"
              image   = "us.gcr.io/cloudsql-docker/gce-proxy"
              command = ["/bin/sh", "-c", "date; echo Hello from the Kubernetes cluster"]
            }
          }
        }
      }
    }
  }
}
