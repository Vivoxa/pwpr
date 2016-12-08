class BusinessesController < BaseController
  before_action :set_business, only: %i(show edit update destroy)
  before_filter :authenticate_company_operator

  # GET /businesses
  # GET /businesses.json
  def index
    raise 'Must have a scheme id to view businesses' if params['scheme_id'].nil?
    @businesses = current_user.schemes.find(params['scheme_id']).businesses
  end

  # GET /businesses/1
  # GET /businesses/1.json
  def show; end

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
    create_business_or_scheme(@business)
  end

  # PATCH/PUT /businesses/1
  # PATCH/PUT /businesses/1.json
  def update
    update_object(@business, businesses_url, business_params)
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
    params.require(:business).permit(:name, :membership_no, :company_no, :NPWD, :SIC, :scheme_id)
  end
end
