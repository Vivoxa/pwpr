module DeviseOverrides
  class SchemeOperatorInvitationsController < Devise::InvitationsController
    before_action :configure_permitted_parameters, if: :devise_controller?
    include CommonHelpers::MultiUserTypesHelper

    # GET /resource/invitation/new
    def new
      @schemes = if current_scheme_operator&.schemes
                 elsif current_admin
                   Scheme.all
                 else
                   []
                 end
      self.resource = resource_class.new
      render :new
    end

    protected

    def authenticate_inviter!
      authenticate_admin!(force: true) if current_admin
      authenticate_scheme_operator! if current_scheme_operator
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:invite) do |user_params|
        user_params.permit({scheme_ids: []}, :email, :name)
      end
    end
  end
end
