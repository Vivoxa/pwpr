# frozen_string_literal: true
#
module DeviseOverrides
  class RegistrationsController <  Devise::RegistrationsController
    skip_before_action :require_no_authentication
    before_action :authenticate
    before_action :configure_permitted_parameters, if: :devise_controller?

    # POST /resource
    def create
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.is_a? SchemeOperator
          schemes = Scheme.where(id: params['scheme_operator']['scheme_ids'])

          resource.schemes = schemes
        end
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

    # Build a devise resource passing in the session. Useful to move
    # temporary session data to the newly created user.
    def build_resource(hash = nil)
      self.resource = resource_class.new_with_session(hash || {}, session)
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) do |user_params|
        user_params.permit({ scheme_ids: [] }, :email, :password, :password_confirmation, :name)
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
