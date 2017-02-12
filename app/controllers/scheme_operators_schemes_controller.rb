class SchemeOperatorsSchemesController < ApplicationController
  load_and_authorize_resource :scheme
  load_and_authorize_resource :scheme_operators_scheme, through: :scheme

  before_action :set_scheme_operators_scheme, only: %i(show destroy)

  # GET /scheme_operators_schemes
  # GET /scheme_operators_schemes.json
  def index
    @scheme = Scheme.find(params[:scheme_id].to_i)
    @scheme_operators_schemes = SchemeOperatorsScheme.where(scheme_id: @scheme.id).where('scheme_operator_id != ?', current_user.id)
  end

  # GET /scheme_operators_schemes/new
  def new
    @scheme_operators_scheme = SchemeOperatorsScheme.new
    @scheme = Scheme.find(params[:scheme_id].to_i)
    @scheme_operators = current_user.schemes.flat_map(&:scheme_operators) - [current_user]
  end

  # POST /scheme_operators_schemes
  # POST /scheme_operators_schemes.json
  def create
    @scheme_operators_scheme = SchemeOperatorsScheme.new(scheme_operators_scheme_params)

    respond_to do |format|
      if @scheme_operators_scheme.save
        format.html { redirect_to scheme_scheme_operators_schemes_path, notice: 'Scheme Operator successfully linked' }
        format.json { render :show, status: :created, location: @scheme_operators_scheme }
      else
        format.html { render :new }
        format.json { render json: @scheme_operators_scheme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scheme_operators_schemes/1
  # DELETE /scheme_operators_schemes/1.json
  def destroy
    @scheme_operators_scheme.destroy
    respond_to do |format|
      format.html { redirect_to scheme_scheme_operators_schemes_path, notice: 'Scheme operator was successfully de-linked.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_scheme_operators_scheme
    @scheme_operators_scheme = SchemeOperatorsScheme.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def scheme_operators_scheme_params
    params.require(:scheme_operators_scheme).permit(:scheme_id, :scheme_operator_id)
  end
end
