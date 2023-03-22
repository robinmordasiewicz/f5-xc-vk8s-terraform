resource "volterra_namespace" "namespace" {
  name = var.namespace
}

resource "time_sleep" "wait_n_seconds" {
  depends_on      = [volterra_namespace.namespace]
  create_duration = "20s"
}

resource "null_resource" "next" {
  depends_on = [time_sleep.wait_n_seconds]
}

resource "volterra_healthcheck" "healthcheck" {
  name                     = "http-healthcheck"
  depends_on               = [null_resource.next]
  namespace                = volterra_namespace.namespace.name
  http_health_check {
    path                   = "/"
    use_origin_server_name = true
    use_http2              = true
  }
  timeout                  = 3
  interval                 = 15
  unhealthy_threshold      = 1
  healthy_threshold        = 3
}

resource "volterra_origin_pool" "origin-pool" {
  name                   = "http-origin-pool"
  depends_on             = [volterra_healthcheck.healthcheck]
  namespace              = volterra_namespace.namespace.name
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  origin_servers {
    public_name {
      dns_name = "www.nginx.com"
    }
  }
  port = 443
  use_tls {
      skip_server_verification = false
      use_host_header_as_sni = false
      volterra_trusted_ca = true
      no_mtls = true
      tls_config {
        default_security = true
      }
  }
  healthcheck {
    name = volterra_healthcheck.healthcheck.name
  }
}

resource "volterra_http_loadbalancer" "http-lb" {
  name      = "http-lb"
  namespace              = volterra_namespace.namespace.name

  advertise_on_public_default_vip = true

  // One of the arguments from this list "api_definition api_specification api_definitions disable_api_definition" must be set
  disable_api_definition = true

  // One of the arguments from this list "enable_api_discovery disable_api_discovery" must be set

  enable_api_discovery {
    // One of the arguments from this list "disable_learn_from_redirect_traffic enable_learn_from_redirect_traffic" must be set
    disable_learn_from_redirect_traffic = true
  }
  // One of the arguments from this list "no_challenge js_challenge captcha_challenge policy_based_challenge" must be set
  no_challenge = true

  // One of the arguments from this list "enable_ddos_detection disable_ddos_detection" must be set

  enable_ddos_detection {
    // One of the arguments from this list "disable_auto_mitigation enable_auto_mitigation" must be set
    enable_auto_mitigation = true
  }
  domains = ["${var.fqdn}"]
  // One of the arguments from this list "random source_ip_stickiness cookie_stickiness ring_hash round_robin least_active" must be set
  round_robin = true

  // One of the arguments from this list "https_auto_cert https http" must be set
  https_auto_cert {
    http_redirect = false
    add_hsts = false
    port = 443
    tls_config {
      default_security = true
    }
    no_mtls = true
    default_header = true
    header_transformation_type {
      default_header_transformation = true
    }
    non_default_loadbalancer = true
  }

  // One of the arguments from this list "enable_malicious_user_detection disable_malicious_user_detection" must be set
  enable_malicious_user_detection = true

  // One of the arguments from this list "disable_rate_limit api_rate_limit rate_limit" must be set

  rate_limit {
    // One of the arguments from this list "no_ip_allowed_list ip_allowed_list custom_ip_allowed_list" must be set

  no_ip_allowed_list = true

    // One of the arguments from this list "no_policies policies" must be set
    no_policies = true

    rate_limiter {
      burst_multiplier = "1"
      total_number     = "1"
      unit             = "unit"
    }
  }
  // One of the arguments from this list "service_policies_from_namespace no_service_policies active_service_policies" must be set
  service_policies_from_namespace = true

  // One of the arguments from this list "disable_trust_client_ip_headers enable_trust_client_ip_headers" must be set

  enable_trust_client_ip_headers {
    client_ip_headers = ["Client-IP-Header"]
  }
  // One of the arguments from this list "user_id_client_ip user_identification" must be set
  user_id_client_ip = true
  // One of the arguments from this list "disable_waf app_firewall" must be set
  disable_waf = true
  default_route_pools {
    pool {
      namespace = volterra_namespace.namespace.name
      name      = volterra_origin_pool.origin-pool.name
    }
    weight           = 1
    priority         = 1
  }
}
