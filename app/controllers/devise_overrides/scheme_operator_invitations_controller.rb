module DeviseOverrides
  class SchemeOperatorInvitationsController < Devise::InvitationsController
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_filter :authenticate_scheme_operator, only: %i(new create)
    authorize_resource class: SchemeOperatorInvitationsController

    include CommonHelpers::MultiUserTypesHelper

    # GET /resource/invitation/new
    def new
      @schemes = if current_scheme_operator
                   current_scheme_operator&.schemes
                 elsif current_admin
                   Scheme.all
                 else
                   []
                 end
      self.resource = resource_class.new
      render :new
    end

    # POST /resource/invitation
    def create
      self.resource = invite_resource
      resource_invited = resource.errors.empty?

      yield resource if block_given?

      if resource_invited
        if is_flashing_format? && resource.invitation_sent_at
          set_flash_message :notice, :send_instructions, email: resource.email
        end
        begin
          if method(:after_invite_path_for).arity == 1
            respond_with resource, location: after_invite_path_for(current_inviter)
          else
            respond_with resource, location: after_invite_path_for(current_inviter, resource)
          end
        rescue
          redirect_to scheme_operators_path
        end
      else
        respond_with_navigational(resource) { render :new }
      end
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
