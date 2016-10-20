class CompanyOperatorsController < ApplicationController
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

  # PATCH/PUT /company_operators/:id
  def update
    @company_operator = CompanyOperator.find(params[:id])
    if @company_operator.update_attributes(secure_params)
      redirect_to company_operators_path, notice: 'User updated.', status: :ok # 200
    else
      redirect_to company_operator_path, alert: 'Unable to update user.', status: :unprocessable_entity # 422
    end
  end

  # DELETE /company_operators/:id
  def destroy
    @company_operator = CompanyOperator.find(params[:id])
    @company_operator.destroy
    redirect_to company_operators_path, notice: 'User deleted.', status: :ok
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
    params.require(:company_operator).permit(:role)
  end
end
