import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    
    console.log("here")
    var tags = document.getElementsByName("response_tags")[0].value.split(" ");
    for (var i = 0; i < tags.length; i++) {
      document.getElementById(`neighbour-response-tags-${tags[i]}-field`).click()
    }  
  }
}
