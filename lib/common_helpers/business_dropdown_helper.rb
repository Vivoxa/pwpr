module CommonHelpers
  module BusinessDropdownHelper
    def update_businesses
      schemes = Scheme.where('id = ?', params[:scheme_id])
      @businesses = []
      @businesses = schemes.first.businesses if schemes.any?

      respond_to do |format|
        format.js
      end
    end
  end
end
