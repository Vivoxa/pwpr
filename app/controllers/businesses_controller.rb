class BusinessesController < BaseController
  include Businesses

  before_action :set_business, only: %i(show edit update destroy)
  before_filter :authenticate_company_operator
  before_action :form_dropdown_values, :scheme_id, only: %i(new create edit)

  load_and_authorize_resource

  # GET /businesses
  # GET /businesses.json
  def index
    raise 'Must have a scheme id to view businesses' if params['scheme_id'].nil?
    @businesses = current_user.schemes.find(params['scheme_id']).businesses.order(:name)
    @scheme = Scheme.find(params['scheme_id'].to_i)
  end

  # GET /businesses/1
  # GET /businesses/1.json
  def show
    @registration = @business.registrations.last ? @business.registrations.last : Registration.new(business: @business)
  end

  # GET /businesses/new
  def new
    @business = Business.new
    @schemes = current_user.schemes
    raise 'The currently logged in Scheme Operator must have at least one Scheme to create a business' if @schemes.empty?
  end

  # GET /businesses/1/edit
  def edit; end

  # POST /businesses
  # POST /businesses.json
  def create
    @schemes = current_user.schemes
    @business = Business.new(business_params)
    @business.holding_business_id = params[:holding_business_id].to_i if params[:holding_business_id]
    create_business_or_scheme(@business)
  end

  # PATCH/PUT /businesses/1
  # PATCH/PUT /businesses/1.json
  def update
    update_object(@business, "#{businesses_url}?scheme_id=#{@business.scheme_id}", business_params)
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    destroy_business_or_scheme(@business, businesses_url)
  end

  def scheme_businesses
    @display_holding_co_dropdown = params[:company_subtype] == 'Subsidiary Co'
    @businesses = Scheme.find(scheme_id).businesses.where(business_subtype_id: BusinessSubtype.id_from_setting('Holding Co'))
    respond_to do |format|
      format.js
    end
  end

  private

  def scheme_id
    @scheme_id ||= if params[:business] && params[:business][:scheme_id]
                     params[:business][:scheme_id].to_i
                   elsif params[:scheme_id]
                     params[:scheme_id].to_i
                   end
  end

  def form_dropdown_values
    @business_types ||= BusinessType.all
    @business_subtypes ||= BusinessSubtype.all
    @country_of_business_registrations ||= CountryOfBusinessRegistration.all
    @scheme_status_codes ||= SchemeStatusCode.all
    @registration_status_codes ||= RegistrationStatusCode.all
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_business
    @business = Business.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def business_params
    params.require(:business).permit(:name, :membership_no, :company_number,
                                     :NPWD, :sic_code_id, :scheme_id, :company_subtype,
                                     :scheme_ref, :business_type_id,
                                     :business_subtype_id, :year_first_reg,
                                     :holding_business_id, :scheme_status_code_id,
                                     :registration_status_code_id, :year_last_reg,
                                     :scheme_status_code_id, :registration_status_code_id,
                                     :small_producer, :country_of_business_registration_id)
  end
end
