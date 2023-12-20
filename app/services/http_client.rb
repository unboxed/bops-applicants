# frozen_string_literal: true

class HttpClient
  attr_reader :api_base_url

  def initialize
    @api_base_url = "#{Rails.configuration.api_protocol}://#{api_base}/"
  end

  def connection
    Faraday.new(url: api_base_url) do |faraday|
      faraday.response :logger, Rails.logger do |logger|
        logger.filter(/(Authorization:\s*)\S*$/, '\1[FILTERED]')
      end

      faraday.adapter Faraday.default_adapter
      faraday.headers["Content-Type"] = "application/json"
      faraday.headers["Authorization"] = authorization_header
    end
  end

  # FIXME: to use Faraday for file uploads
  def http_party(endpoint, method, params)
    HTTParty.send(method,
      "#{api_base_url}#{endpoint}",
      headers: {Authorization: authorization_header},
      body: params.merge(file_params_body(params)))
  end

  private

  def file_params_body(params)
    {}.tap do |hash|
      hash[:new_file] = params[:file] if params[:file]
      hash[:files] = params[:files] if params[:files]
    end
  end

  def api_base
    "#{Current.local_authority}.#{Rails.configuration.api_host}/api/v1"
  end

  def authorization_header
    "Bearer #{Rails.configuration.api_bearer}"
  end
end
