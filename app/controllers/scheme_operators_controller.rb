class SchemeOperatorsController < ApplicationController
  before_filter :authenticate_scheme_operator
  load_and_authorize_resource

  # GET /scheme_operators
  def index
    # TODO: this needs scoping to a scheme
    @scheme_operators = SchemeOperator.all
  end

  # GET /scheme_operators/:id
  def show
    # We need to figure a scope to search for users dynamically based on the category
    # in order to be able to search for the one clicked on in the right table
    @scheme_operator = SchemeOperator.find(params[:id])
  end

  # PATCH/PUT /scheme_operators/:id
  def update
    @scheme_operator = SchemeOperator.find(params[:id])
    @scheme_operator.update_attributes(secure_params)
  end

  # DELETE /scheme_operators/:id
  def destroy
    @scheme_operator = SchemeOperator.find(params[:id])
    @scheme_operator.destroy
  end

  # GET /scheme_operators/:id/permissions
  def permissions
    @user = SchemeOperator.find_by_id(params[:scheme_operator_id])
    @available_roles = SchemeOperator::ROLES
    @available_permissions = SchemeOperator::PERMISSIONS
  end

  # PUT /scheme_operators/:id/update_permissions
  def update_permissions
    @user = SchemeOperator.find_by_id(params[:scheme_operator_id])

    modify_roles_and_permissions
  end

  private

  def secure_params
    # We need to pull the params and handle company_operator as well maybe?
    params.require(:scheme_operator).permit(:role)
  end
end
