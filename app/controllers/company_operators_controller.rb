class CompanyOperatorsController < BaseController
  before_action :authenticate_company_operator
  load_and_authorize_resource

  # GET /company_operators
  # TODO: requires scoping
  def index
    @company_operator = CompanyOperator.all
  end

  # GET /company_operators/:id
  def show
    @company_operator = CompanyOperator.find(params[:id])
  end

  # GET /company_operators/1/edit
  def edit
  end

  # PATCH/PUT /company_operators/:id
  def update
    update_operator(@company_operator, secure_params, company_operators_path)
  end

  # DELETE /company_operators/:id
  def destroy
    destroy_operator(@company_operator, company_operators_path)
  end

  # GET /company_operators/:id/permissions
  def permissions
    @user = CompanyOperator.find_by_id(params[:company_operator_id])
    @available_roles = CompanyOperator::ROLES
    @available_permissions = CompanyOperator::PERMISSIONS
  end

  # GET /company_operators/:id/permissions
  def update_permissions
    @user = CompanyOperator.find_by_id(params[:company_operator_id])

    modify_roles_and_permissions
  end

  private

  def secure_params
    # We need to pull the params and handle company_operator as well maybe?
    params.require(:company_operator).permit(:role, :name, :email)
  end
end
