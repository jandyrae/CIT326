terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}
provider "google" {
  project = "scenarioweek10"
  region  = "us-central1"
}
#--------------1st mysql----------------
resource "google_sql_database" "mysqlDev" {
  name     = "kiger-dev-db-0"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_database_instance" "instance" {
  name             = "kiger-development1"
  region           = "us-central1"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      authorized_networks {
        name  = "Allowed Network"
        value = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = "false"
}

resource "google_sql_user" "mysqlDevUser" {
  name     = "dev-user-1"
  instance = google_sql_database_instance.instance.name
  password = "notSecure"
}
#--------------1st mysql----------------
resource "google_sql_database" "mysqlDB" {
  name     = "kiger-dev-db-1"
  instance = google_sql_database_instance.mysql_kiger_development0.name
}

resource "google_sql_database_instance" "mysql_kiger_development0" {
  name             = "kiger-development-1"
  region           = "us-central1"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      authorized_networks {
        name  = "Allowed Network"
        value = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = "false"
}

resource "google_sql_user" "mysql-dev-user" {
  name     = "dev-user"
  instance = google_sql_database_instance.mysql_kiger_development0.name
  password = "notSecure"
}

# -----2nd mysql ----------------------------
resource "google_sql_database" "integrationtestdb" {
  name     = "mysql-kiger-integrationtest-db"
  instance = google_sql_database_instance.mysql_kiger_integrationtest.name
}
resource "google_sql_database_instance" "mysql_kiger_integrationtest" {
  name             = "mysql-kiger-integrationtest"
  region           = "us-central1"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      authorized_networks {
        name  = "Allowed Network"
        value = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = "false"
}
resource "google_sql_user" "mysql_int_user" {
  name     = "mysql-int-user"
  instance = google_sql_database_instance.mysql_kiger_integrationtest.name
  password = "notSecure"
}
# ----- 3rd mysql ---------------------------
resource "google_sql_database" "mysql_kiger_qa_db" {
  name     = "mysql-kiger-qa-db"
  instance = google_sql_database_instance.mysql_kiger_qa.name
}
resource "google_sql_database_instance" "mysql_kiger_qa" {
  name             = "mysql-kiger-qa"
  region           = "us-central1"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      authorized_networks {
        name  = "Allowed Network"
        value = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = "false"
}
resource "google_sql_user" "mysql_qa_user" {
  name     = "mysql-qa-user"
  instance = google_sql_database_instance.mysql_kiger_qa.name
  password = "notSecure"
}

# --------- postgres terraform database ------------------------------
resource "google_sql_database" "postgres_kiger_development_db" {
  name     = "postgres-kiger-dev-db"
  instance = google_sql_database_instance.postgres_kiger_development.name
}

resource "google_sql_database_instance" "postgres_kiger_development" {
  name             = "postgres-db-dev"
  region           = "us-central1"
  database_version = "POSTGRES_13"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      authorized_networks {
        name  = "Allowed Network"
        value = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = "false"
}

resource "google_sql_user" "postgre_dev_user" {
  name     = "postgre-dev-user"
  instance = google_sql_database_instance.postgres_kiger_development.name
  password = "notSecure"
}
# ------2nd postgres
resource "google_sql_database" "postgres_kiger_integrationtest_db" {
  name     = "postgres-kiger-int-test-db"
  instance = google_sql_database_instance.postgres_kiger_integrationtest.name
}

resource "google_sql_database_instance" "postgres_kiger_integrationtest" {
  name             = "postgres-db-integrationtest"
  region           = "us-central1"
  database_version = "POSTGRES_13"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      authorized_networks {
        name  = "Allowed Network"
        value = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = "false"
}

resource "google_sql_user" "postgre_int_user" {
  name     = "postgre-int-user"
  instance = google_sql_database_instance.postgres_kiger_integrationtest.name
  password = "notSecure"
}
# -----------3rd postgres
resource "google_sql_database" "postgres_kiger_qa_db" {
  name     = "postgres-kiger-qa-db"
  instance = google_sql_database_instance.postgres_kiger_qa.name
}

resource "google_sql_database_instance" "postgres_kiger_qa" {
  name             = "postgres-db-qa"
  region           = "us-central1"
  database_version = "POSTGRES_13"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      authorized_networks {
        name  = "Allowed Network"
        value = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = "false"
}

resource "google_sql_user" "postgre_qa_user" {
  name     = "postgre-qa-user"
  instance = google_sql_database_instance.postgres_kiger_qa.name
  password = "notSecure"
}
