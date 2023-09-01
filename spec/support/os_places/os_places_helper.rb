# frozen_string_literal: true

module OsPlacesHelper
  def stub_os_places_api_request_for(query)
    stub_request(:get, "https://api.os.uk/search/places/v1/find?key=testtest&maxresults=20&query=#{query}").to_return(os_places_api_response(200))
  end

  def os_places_api_response(status)
    status = Rack::Utils.status_code(status)

    body = "{'results': [{'address': '123 place'}]}"

    { status:, body: }
  end
end
