class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource

  include CommonHelpers::MultiUserTypesHelper

  protected

  def authenticate_scheme_operator
    authenticate_scheme_operator!(force: true) unless current_admin
    authenticate_admin!(force: true) unless current_scheme_operator
  end

  def authenticate_company_operator
    authenticate_company_operator!(force: true) unless current_scheme_operator
    authenticate_scheme_operator!(force: true) unless current_company_operator
    authenticate_admin!(force: true) unless current_scheme_operator || current_company_operator
  end

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end
end
