terraform {
  required_providers {
    heroku = {
      source = "heroku/heroku"
      version = "2.6.0"
    }
  }
}

provider "heroku" {
  version = "~> 2.0"
}

module "service" {
  source = "git::https://github.com/daretodave/taff-platform//common/strategy/http"
  name = "echo"
}

resource "heroku_app" "edge" {
  name = "taff-echo-edge"
  acm = true
  region = "us"
  organization {
    name = "taff"
  }
}

resource "heroku_build" "edge-build" {
  app = heroku_app.edge.name
  source = {
    path = "service"
  }
}

resource "heroku_formation" "edge-config" {
  app        = heroku_app.edge.name
  type       = "web"
  quantity   = 2
  size       = "Standard-1x"
  depends_on = [heroku_build.edge-build]
}

resource "heroku_app_release" "edge-release" {
  app = heroku_app.edge.id
  slug_id = heroku_build.edge-build.slug_id
}

resource "heroku_formation" "edge-host" {
  app = heroku_app.edge.id
  type = "web"
  quantity = 2
  size = "standard-1x"
  depends_on = [
    heroku_app_release.edge-release]
}


resource "heroku_app" "stage" {
  name = "taff-echo-stage"

  region = "us"
  organization {
    name = "taff"
  }
}

resource "heroku_app" "prod" {
  name = "taff-echo-prod"

  region = "us"
  organization {
    name = "taff"
  }
}


resource "heroku_pipeline_coupling" "edge-rule" {
  app = heroku_app.edge.name
  pipeline = heroku_pipeline.pipeline.id
  stage = "development"
}

resource "heroku_pipeline_coupling" "stage-rule" {
  app = heroku_app.stage.name
  pipeline = heroku_pipeline.pipeline.id
  stage = "staging"
}

resource "heroku_pipeline_coupling" "prod-rule" {
  app = heroku_app.prod.name
  pipeline = heroku_pipeline.pipeline.id
  stage = "production"
}

resource "heroku_pipeline" "pipeline" {
  name = "taff-service-echo"
  owner {
    id = "6a5b3068-3231-41d4-9d95-bdba671ad28f"
    type = "team"
  }
}