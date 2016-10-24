module CommonHelpers
  module BusinessDropdownHelper
    def update_businesses
      schemes = Scheme.where('id = ?', params[:scheme_id])
      @businesses = if schemes.any?
                      schemes.first.businesses
                    else
                      []
                    end

      respond_to do |format|
        format.js
      end
    end
  end
end
