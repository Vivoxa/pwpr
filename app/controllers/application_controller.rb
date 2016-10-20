class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, alert: exception.message
  end
  before_filter :current_user

  include CommonHelpers::MultiUserTypesHelper
  include CommonHelpers::PermissionsHelper

  protected

  def authenticate_scheme_operator
    return true if current_admin
    authenticate_scheme_operator!(force: true)
  end

  def authenticate_company_operator
    return true if current_scheme_operator || current_admin
    authenticate_company_operator!(force: true)
  end

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end
end
