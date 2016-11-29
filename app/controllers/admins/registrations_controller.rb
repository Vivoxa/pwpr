# frozen_string_literal: true
module Admins
  class RegistrationsController < Devise::RegistrationsController
    skip_before_action :require_no_authentication
    before_action :configure_permitted_parameters, if: :devise_controller?
    authorize_resource class: Admins::RegistrationsController

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) do |user_params|
        user_params.permit(:email,
                           :password,
                           :password_confirmation,
                           :name)
      end
    end
  end
end
