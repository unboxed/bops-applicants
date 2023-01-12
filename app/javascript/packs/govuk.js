require("govuk-frontend/govuk/all").initAll()
require.context('govuk-frontend/govuk/assets/images', true)

document.body.className = ((document.body.className) ? `${document.body.className} js-enabled` : 'js-enabled');
