module SchemeOperators
  class InvitationsController < BaseInvitationsController
    before_filter :authenticate_scheme_operator, only: %i(new create)
    authorize_resource class: SchemeOperators::InvitationsController

    include CommonHelpers::MultiUserTypesHelper

    protected

    def authenticate_inviter!
      return true if current_admin || current_scheme_operator
      authenticate_scheme_operator
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:invite) do |user_params|
        user_params.permit({scheme_ids: []}, :email, :first_name, :last_name, :scheme_ids)
      end
    end
  end
end
