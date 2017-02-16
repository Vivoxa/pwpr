class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include CommonHelpers::MultiUserTypesHelper
  include CommonHelpers::PermissionsHelper
  include CommonHelpers::LogHelper

  layout :layout_by_resource

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, alert: exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    Rails.logger.error "ActiveRecord::RecordNotFound - Params: #{params}. Error: #{exception.message}"
    redirect_to main_app.root_url, alert: 'You are not authorized to access this page.'
  end

  before_filter :current_user
  around_action :tag_logs

  def after_sign_in_path_for(_resource)
    '/'
  end

  protected

  def error_redirect(path, error_msg)
    flash[:error] = error_msg
    redirect_to path
  end


  def current_ability
    user = @current_user || Visitor.new
    @current_ability ||= Abilities.ability_for(user)
  end

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
