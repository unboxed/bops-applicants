require("govuk-frontend").initAll()

document.body.className = document.body.className
  ? `${document.body.className} js-enabled`
  : "js-enabled"
