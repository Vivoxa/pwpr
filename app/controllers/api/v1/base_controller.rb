class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :destroy_session
  before_filter :authenticate

  private

  def authenticate
    authenticate_or_request_with_http_basic do |source_app, api_key|
      service = SERVICE_CONFIG['services'][source_app]
      service && service['private_key'] == api_key
      end
  end

  def destroy_session
    request.session_options[:skip] = true
  end
end