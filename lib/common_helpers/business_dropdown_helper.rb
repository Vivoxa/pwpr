module CommonHelpers
  module BusinessDropdownHelper
    include Logging

    def update_businesses
      logger.tagged('BusinessDropdownHelper(Mod)') do
        schemes = Scheme.where('id = ?', params[:scheme_id])
        @businesses = []
        @businesses = schemes.first.businesses if schemes.any?
        logger.info "update_businesses() - returning businesses for dropdown for scheme_id: #{params[:scheme_id]} in js format"
        respond_to do |format|
          format.js
        end
      end
    end
  end
end
