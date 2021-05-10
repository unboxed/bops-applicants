class ApplicationController < ActionController::Base
  helper_method :current_local_authority

  def current_local_authority
    request.subdomains.first
  end
end
