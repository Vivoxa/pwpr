module CompanyOperators
  class InvitationsController < BaseInvitationsController
    authorize_resource class: CompanyOperators::InvitationsController
    before_filter :authenticate_company_operator, only: %i(new create)
    include CommonHelpers::MultiUserTypesHelper
    include CommonHelpers::BusinessDropdownHelper
    respond_to :js

    protected

    def authenticate_inviter!
      return true if current_admin || current_scheme_operator
      authenticate_company_operator!(force: true)
    end
  end
end
