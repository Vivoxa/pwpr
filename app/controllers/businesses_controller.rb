class BusinessesController < BaseController
  before_action :set_business, only: %i(show edit update destroy)
  before_filter :authenticate_company_operator
  load_and_authorize_resource

  # GET /businesses
  # GET /businesses.json
  def index
    raise 'Must have a scheme id to view businesses' if params['scheme_id'].nil?
    @businesses = current_user.schemes.find(params['scheme_id']).businesses
    @scheme = Scheme.find(params['scheme_id'].to_i)
  end

  # GET /businesses/1
  # GET /businesses/1.json
  def show; end

  # GET /businesses/new
  def new
    @scheme_id = params[:scheme_id].to_i if params[:scheme_id]

    @business = Business.new
    @schemes = current_user.schemes
    raise 'The currently logged in Scheme Operator must have at least one Scheme to create a business' if @schemes.empty?
    @business_types = BusinessType.all
    @business_subtypes = BusinessSubtype.all
  end

  # GET /businesses/1/edit
  def edit; end

  # POST /businesses
  # POST /businesses.json
  def create
    @schemes = current_user.schemes
    @business = Business.new(business_params)
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_business
    @business = Business.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def business_params
    params.require(:business).permit(:name, :membership_no, :company_number,
                                     :NPWD, :sic_code_id, :scheme_id,
                                     :scheme_ref, :business_type_id,
                                     :business_subtype_id, :year_first_reg)
    #:scheme_status_code_id, :registration_status_code_id)
  end
end
