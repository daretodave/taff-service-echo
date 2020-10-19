terraform {
  required_providers {
    heroku = {
      source = "heroku/heroku"
      version = "2.6.0"
    }
  }
}

provider "heroku" {}

module "service" {
  source = "git::https://github.com/daretodave/taff-platform//common/strategy/http"
  name = "echo"
}

resource "heroku_app" "edge" {
  name = "taff-echo-edge"

  region = "us"
  organization {
    name = "taff"
  }
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
  app      = heroku_app.edge.name
  pipeline = heroku_pipeline.pipeline.id
  stage    = "development"
}

resource "heroku_pipeline_coupling" "stage-rule" {
  app      = heroku_app.stage.name
  pipeline = heroku_pipeline.pipeline.id
  stage    = "staging"
}

resource "heroku_pipeline_coupling" "prod-rule" {
  app      = heroku_app.prod.name
  pipeline = heroku_pipeline.pipeline.id
  stage    = "production"
}

resource "heroku_pipeline" "pipeline" {
  name = "taff-service-echo"
}