module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session

      before_action :destroy_session
      before_filter :authenticate

      private

      def authenticate
        authenticate_or_request_with_http_basic do |source_app, api_key|
          service = SERVICE_CONFIG['services']['api'].include?(source_app)
          service && ENV.fetch('API_KEY') == api_key
        end
      end

      def destroy_session
        request.session_options[:skip] = true
      end
    end
  end
end
