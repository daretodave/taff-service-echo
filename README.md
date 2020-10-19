# echo api


## set up
> this is just a POC, apologies for lacking documention


the set up below only happens once and should take 5-10 minutes

### step #1 

- set up deployment "paths" for the service, and the soon to be automation steps
- domain mapping w/ TLS on the provided custom domain
- dyno stack with heroku pipeline

 Sett up an API key through the CLI (or from settings in the heroku dashboard):

 ```bash
 heroku authorizations:create --description developer-auth
 ```

Expore for terraform to use

```bash
export HEROKU_EMAIL="ops@company.com"
export HEROKU_API_KEY="heroku_api_key"
```

Deploy
```bash
terraform init
terraform plan
terraform deploy
```

### step #2

This is a manual step, no way around the GHE oauth connect flow at the moment. This will:
- Enable status checks for the GH repository
- Enable per-branch deployments of the application on a custom domain w/ optional env

From the heroku dashboard, navigate to pipeline settings (for the one visible pipe and team) and:
- Authenticate to GH repo
- Enable Review Apps (check all options offered and leave the rest defaulted)
- Enable Heroku CI

> There is some discovery to be done to see if this step can just be automated


#### observe
This API will not cost anything until traffic picks up, all services use the free tier or elastic options to scall down

to come: alerts; logging; configuration; and cloud provider instructions.