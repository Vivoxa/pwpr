module DeviseOverrides
  class SchemeOperatorInvitationsController < Devise::InvitationsController
    before_action :configure_permitted_parameters, if: :devise_controller?
    skip_before_action :require_no_authentication
    before_action :authenticate

    include CommonHelpers::MultiUserTypesHelper

      # GET /resource/invitation/new
    def new
      @current_user = current_user
      self.resource = resource_class.new
      render :new
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:invite) do |user_params|
        user_params.permit({ scheme_ids: [] }, :email, :name)
      end
    end

    private

    def authenticate
      redirect_to scheme_operator_session_path unless admin_signed_in? || scheme_operator_signed_in?
      if current_admin
        authenticate_admin!
      else
        authenticate_scheme_operator!
      end
    end
  end
end
