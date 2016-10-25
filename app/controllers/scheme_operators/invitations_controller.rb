module SchemeOperators
  class InvitationsController < BaseInvitationsController
    before_filter :authenticate_scheme_operator, only: %i(new create)
    authorize_resource class: SchemeOperators::InvitationsController

    include CommonHelpers::MultiUserTypesHelper

    # GET /scheme_operator_invitations
    # GET /scheme_operator_invitations.json
    def index
      query = 'invitation_sent_at IS NOT NULL AND invitation_accepted_at IS NULL'
      @scheme_operator_invitations = []
      current_user.schemes.each do |scheme|
        scheme.scheme_operators.where(query).each do |scheme_operator|
          @scheme_operator_invitations << scheme_operator
        end
      end
    end

    protected

    def authenticate_inviter!
      return true if current_admin || current_scheme_operator
      authenticate_scheme_operator!
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:invite) do |user_params|
        user_params.permit({scheme_ids: []}, :email, :name)
      end
    end
  end
end
