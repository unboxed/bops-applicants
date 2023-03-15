# frozen_string_literal: true

class Request
  include HttpStatusCodes

  class BopsApiError < StandardError; end

  class RecordNotFoundError < BopsApiError; end

  class BadRequestError < BopsApiError; end

  class TimeoutError < BopsApiError; end

  class UnauthorizedError < BopsApiError; end

  class ForbiddenError < BopsApiError; end

  class RequestEntityTooLargeError < BopsApiError; end

  class ApiError < BopsApiError; end

  def initialize(http_method, endpoint, params, upload_file)
    @connection = HttpClient.new.connection
    @http_method = http_method
    @endpoint = endpoint
    @params = params
    @upload_file = upload_file
  end

  attr_reader :endpoint

  def call # rubocop:disable Metrics/CyclomaticComplexity
    response, status = get_response_and_status

    case status
    when OK, NO_CONTENT
      response
    when NOT_FOUND
      raise RecordNotFoundError, errors(response, status)
    when BAD_REQUEST
      raise BadRequestError, errors(response, status)
    when UNAUTHORIZED
      raise UnauthorizedError, errors(response, status)
    when FORBIDDEN
      raise ForbiddenError, errors(response, status)
    when TIMEOUT_ERROR
      raise TimeoutError, errors(response, status)
    when REQUEST_ENTITY_TOO_LARGE
      raise RequestEntityTooLargeError, errors(response, status)
    else
      raise ApiError, errors(response, status)
    end
  end

  private

  attr_reader :connection, :http_method, :params, :upload_file

  def errors(response, status)
    { response:, status:, http_method: }
  end

  def get_response_and_status # rubocop:disable Metrics/AbcSize, Naming/AccessorMethodName
    raise RecordNotFoundError, errors("Not found", NOT_FOUND) if endpoint.blank?

    if upload_file
      # FIXME: to use Faraday for file uploads
      response = HttpClient.new.http_party(endpoint, params)
      [response.parsed_response, response.code]
    else
      response = connection.public_send(http_method, endpoint, params)
      [JSON.parse(response.body), response.status]
    end
  end
end
