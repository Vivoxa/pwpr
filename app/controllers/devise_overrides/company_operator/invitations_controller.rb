module DeviseOverrides
  module CompanyOperator
    class InvitationsController < BaseInvitationsController
      authorize_resource class: DeviseOverrides::CompanyOperator::InvitationsController
      before_filter :authenticate_company_operator, only: %i(new create)
      include CommonHelpers::MultiUserTypesHelper

      respond_to :js

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

      protected

      def authenticate_inviter!
        return true if current_admin || current_scheme_operator
        authenticate_company_operator!(force: true)
      end
    end
  end
end
