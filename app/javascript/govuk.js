require("govuk-frontend/govuk/all").initAll()

document.body.className = document.body.className
  ? `${document.body.className} js-enabled`
  : "js-enabled"
