class BaseInvitationsController < Devise::InvitationsController
  authorize_resource class: BaseInvitationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  include CommonHelpers::MultiUserTypesHelper

  # GET /resource/invitation/new
  def new
    populate_schemes_and_businesses
    self.resource = resource_class.new
    render :new
  end

  def current_inviter
    current_admin || current_scheme_operator || current_company_operator
  end

  protected

  def populate_schemes_and_businesses
    @schemes = if current_scheme_operator
                 current_scheme_operator&.schemes
               elsif current_admin
                 Scheme.all
               elsif current_company_operator
                 [current_company_operator.business.scheme]
               end
    businesses = []
    if current_company_operator
      businesses << current_company_operator.business
    else
      @schemes.each do |scheme|
        scheme.businesses.each do |business|
          businesses << business
        end
      end
    end
    @businesses = businesses.flatten
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite) do |user_params|
      user_params.permit({scheme_ids: []}, :email, :name, :business_id)
    end
  end
end
