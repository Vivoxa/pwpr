class BaseInvitationsController < Devise::InvitationsController
  include CommonHelpers::MultiUserTypesHelper
  include CommonHelpers::LogHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :tag_logs

  # GET /resource/invitation/new
  def new
    if params[:scheme_id]
      @scheme_id = params[:scheme_id].to_i
      @scheme = Scheme.find(params[:scheme_id].to_i)
    end

    populate_schemes_and_businesses
    self.resource = resource_class.new
    render :new
  end

  def create
    populate_schemes_and_businesses
    super

    if params[:scheme_operator] && params[:scheme_operator][:scheme_id]
      resource.schemes << Scheme.find(params[:scheme_operator][:scheme_id].to_i)
      resource.save!
    end
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
      user_params.permit({scheme_ids: []}, :email, :first_name, :last_name, :business_id)
    end
  end
end
