class SchemesController < BaseController
  before_filter :authenticate_scheme_operator
  before_action :set_scheme, only: %i(show edit update destroy)
  load_and_authorize_resource

  # GET /schemes
  # GET /schemes.json
  def index
    @schemes = current_user.schemes
  end

  # GET /schemes/1
  # GET /schemes/1.json
  def show; end

  # GET /schemes/new
  def new
    @scheme = Scheme.new
  end

  # GET /schemes/1/edit
  def edit; end

  # POST /schemes
  # POST /schemes.json
  def create
    @scheme = Scheme.new(scheme_params)
    create_business_or_scheme(@scheme)
  end

  # PATCH/PUT /schemes/1
  # PATCH/PUT /schemes/1.json
  def update
    update_object(@scheme, schemes_url, scheme_params)
  end

  # DELETE /schemes/1
  # DELETE /schemes/1.json
  def destroy
    destroy_business_or_scheme(@scheme, schemes_url)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_scheme
    @scheme = Scheme.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def scheme_params
    params.require(:scheme).permit(:name, :active)
  end
end
