terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}
provider "google" {
  project = "scenarioweek10"
  region  = "us-central1"
}
resource "google_sql_database_instance" "mysqlkiger" {
  name = "mysql-instance1-kiger"
  region = "us-central1"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      authorized_networks {
        name = "Allowed Network"
        value = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = "false"
}
resource "google_sql_database" "mysqlkiger" {
  name = "sql-terraform-kiger"
  instance = google_sql_database_instance.mysqlkiger.name
}
resource "google_sql_user" "mysqluser1" {  
    name = "mysql-user-kiger1"
    instance = google_sql_database_instance.mysqlkiger.name
    password = "notSecure"
}
# -----2nd mysql ----------------------------
resource "google_sql_database" "kiger_database_terraform2" {
  name = "sql-terraform2"
  instance = google_sql_database_instance.mysqlterraform2.name
}
resource "google_sql_database_instance" "mysqlterraform2" {
  name = "mysql-instance2"
  region = "us-central1"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
      ip_configuration {
        authorized_networks {
          name = "Allowed Network"
          value = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = "false"
}
resource "google_sql_user" "sql_user_terraform2" {
  name = "example_user2"
  instance = google_sql_database_instance.mysqlterraform2.name
  password = "notSecure"
}
# ----- 3rd mysql ---------------------------
resource "google_sql_database" "kiger_database_terraform3" {
  name = "sql-terraform3"
  instance = google_sql_database_instance.mysqlterraform3.name
}
resource "google_sql_database_instance" "mysqlterraform3" {
  name = "mysql-instance3"
  region = "us-central1"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
      ip_configuration {
        authorized_networks {
          name = "Allowed Network"
          value = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = "false"
}
resource "google_sql_user" "sql_user_terraform3" {
  name = "example_user3"
  instance = google_sql_database_instance.mysqlterraform3.name
  password = "notSecure"
}

# --------- postgres terraform database ------------------------------
resource "google_sql_database" "database_label_terriform1" {
  name = "my-postgres-database1"
  instance = google_sql_database_instance.instanceterraform1.name
}

resource "google_sql_database_instance" "instanceterraform1" {
  name = "postgres-instance1"
  region = "us-central1"
  database_version = "POSTGRES_13"
  settings {
    tier = "db-f1-micro"
      ip_configuration {
        authorized_networks {
          name = "Allowed Network"
          value = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = "false"
}

resource "google_sql_user" "sql_user1_terraform" {
  name = "postgres-user1"
  instance = google_sql_database_instance.instanceterraform1.name
  password = "notSecure"
}
# ------2nd postgres
resource "google_sql_database" "databaseterriform2" {
  name = "my-postgres-database2"
  instance = google_sql_database_instance.instanceterraform2.name
}

resource "google_sql_database_instance" "instanceterraform2" {
  name = "postgres-instance2"
  region = "us-central1"
  database_version = "POSTGRES_13"
  settings {
    tier = "db-f1-micro"
      ip_configuration {
        authorized_networks {
          name = "Allowed Network"
          value = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = "false"
}

resource "google_sql_user" "sql_user2_terraform" {
  name = "postgres_user2"
  instance = google_sql_database_instance.instanceterraform2.name
  password = "notSecure"
}
# -----------3rd postgres
resource "google_sql_database" "databaseterriform3" {
  name = "my-postgres-database3"
  instance = google_sql_database_instance.instanceterraform3.name
}

resource "google_sql_database_instance" "instanceterraform3" {
  name = "postgres-instance3"
  region = "us-central1"
  database_version = "POSTGRES_13"
  settings {
    tier = "db-f1-micro"
      ip_configuration {
        authorized_networks {
          name = "Allowed Network"
          value = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = "false"
}

resource "google_sql_user" "sql_user3_terraform" {
  name = "postgres_user3"
  instance = google_sql_database_instance.instanceterraform3.name
  password = "notSecure"
}

#-------------https://github.com/terraform-google-modules/terraform-docs-samples/blob/main/cloud_sql/database_basic/main.tf
# [START cloud_sql_database_create]
resource "google_sql_database" "database" {
  name     = "my-database"
  instance = google_sql_database_instance.instance.name
}
# [END cloud_sql_database_create]

# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "instance" {
  name             = "my-database-instance"
  region           = "us-central1"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
  }

  deletion_protection = false # set to true to prevent destruction of the resource
}

#https://cloud.google.com/sql/docs/mysql/flags#terraform