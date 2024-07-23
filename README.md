# BOPS Applicants ![CI](https://github.com/unboxed/bops-applicants/workflows/CI/badge.svg)

[BOPS](https://github.com/unboxed/bops)

### What is BOPS Applicants?

BOPS Applicants is a proof-of-concept application made to showcase the different API features of [BOPS](https://github.com/unboxed/bops), the Back Office Planning System.

It allows an interface for applicants to reply to change requests made by planning officers within BOPS. These requests may require additional documents be added, or edits made, to a planning application in order to make it valid.

### Running BOPS Applicants

Note that this application only works if the main BOPS application is already running, as it depends on BOPS for its API calls. 

The easiest way to get started is to follow the instructions in [BOPS](https://github.com/unboxed/bops), as both applications are included in `docker-compose`.

Once BOPS and BOPS Applicants ar running on separate ports, create a planning application and a validation request within the BOPS app. 

After clicking on "Invalidate", a validation request will be emailed and a link will be generated that can be used in the BOPS Applicants app. (Either copy the generated link from the terminal, or generate an API key in Notify to send emails on localhost.)

It is necessary to export or set the following environment variables:

```
export API_USER=api_user
export API_BEARER=123
export PROTOCOL=http
export API_HOST=bops.localhost:3000
```

If BOPS Applicants is not running as part of the BOPS `docker-compose` group, install the application dependencies with Yarn and launch BOPS Applicants on a different port from the main BOPS application:

```
bin/dev
```

It will now be possible to open the URL in the email (or copied from the terminal) and access a planning application's change requests on localhost. The URL will look similar to this example:

```
http://southwark.bops-applicants.localhost:3001/validation_requests?change_access_id=6ea6218075f460e692be1a08fbc0e9&planning_application_id=18
```
## Building production docker

### Create production docker

```sh
docker build -t bops-applicants -f Dockerfile.production .
```

### Run production docker

```sh
docker run --rm -it -p 3000:3000 -e RAILS_SERVE_STATIC_FILES=true -e RAILS_ENV=production -e RAILS_LOG_TO_STDOUT=true -e SECRET_KEY_BASE=secret bops-applicants:latest bundle exec rails s
```

### Run production docker bash

```sh
docker run --rm -it -e RAILS_SERVE_STATIC_FILES=true -e RAILS_ENV=production -e RAILS_LOG_TO_STDOUT=true -e SECRET_KEY_BASE=secret bops-applicants:latest /bin/bash
```

## Github Actions

We use Github Actions as part of our continuous integration process to run and test the application.

## Deployments

Merging into `main` will automatically deploy to the staging ECS environment. To deploy to the production ECS environment requires a manual review of the 'Deploy' GitHub Action by one of the required reviewers.

More information about the infrastructure can be found in this private repo: [BOPS infrastructure repo](https://github.com/unboxed/bops-terraform/).
