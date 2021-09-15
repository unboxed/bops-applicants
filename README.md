# BOPS-applicants ![CI](https://github.com/unboxed/bops-applicants/workflows/CI/badge.svg)

BOPS-applicants is a proof of concept app made to showcase the different API features of BOPS. It serves the purpose of allowing an interface for applicants to reply to change requests - requests made by planning officers to the applicant, requiring documents or requiring other changes made to a planning application that are necessary to make that application valid within the BOPS app.

This app only works together with [BOPS](https://github.com/unboxed/bops) since it's making API calls to that backend. To test locally:

Export a domain to set your APPLICANTS_APP_HOST or set it in your local BOPS ".env" file:

```
export APPLICANTS_APP_HOST=bops-care.link:3001
```

Open the BOPS app in a separate terminal and start your rails server there. Create a planning application and a "validation request" within the BOPS app. After clicking on "Invalidate", a validation request will be emailed and a link will be generated for you to use on the BOPS applicants app. You can copy the generated link from your terminal, or you can generate an API key in notify to send emails to yourself on localhost using notify.

Back on the BOPS-applicants app, you will need to export or set the following ".env" variables:

```
export API_USER=api_user
export API_BEARER=123
export PROTOCOL=http
export API_HOST=bops-care.link:3000
```

Install your app dependencies with yarn and finally launch BOPS-applicants on a different port to BOPS:

```
rails s -p 3001
```

You will now be able to open the URL you've received by email (or copied from your terminal) and access a planning application's change requests on your localhost. Your URL will look similar to this example:

```
http://southwark.bops-care.link:3001/validation_requests?change_access_id=6ea6218075f460e692be1a08fbc0e9&planning_application_id=18
```

### Deployments

Merging into main will automatically push to staging. To push changes from staging to production you will need to login to heroku and promote the app from staging to prod.