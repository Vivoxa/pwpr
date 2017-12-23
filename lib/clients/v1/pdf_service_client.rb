require 'net/http'
require 'uri'

module Clients
  module V1
    class PdfServiceClient
      def create_pdf(params)
        url = server_location + SERVICE_CONFIG['services']['pdf_server']['endpoints']['post_create_pdf']
        uri = URI(url)
        req = Net::HTTP::Post.new uri.path
        req.basic_auth basic_auth[:account], basic_auth[:password]
        req.set_form_data(params)
        Net::HTTP.new(uri.host, uri.port).start do |http|
          return http.request(req)
        end
      end

      def get_form_fields(report_type)
        url = server_location + SERVICE_CONFIG['services']['pdf_server']['endpoints']['get_form_fields']
        uri = URI.parse("#{url}#{report_type}")
        Net::HTTP.start(uri.host, uri.port) do |http|
          request = Net::HTTP::Get.new uri.request_uri
          request.basic_auth basic_auth[:account], basic_auth[:password]
          return http.request request # Net::HTTPResponse object
        end
      end

      private

      def basic_auth
        {account: ENV.fetch('SERVICE_NAME'), password: ENV.fetch('API_KEY')}
      end

      def server_location
        SERVICE_CONFIG['services']['pdf_server'][Rails.env]['v1']['url']
      end
    end
  end
end
