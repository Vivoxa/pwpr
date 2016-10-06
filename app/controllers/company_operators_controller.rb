# frozen_string_literal: true
class CompanyOperatorsController < ApplicationController
  # before_action :authenticate_company_operator!

  def index
    @company_operator = CompanyOperator.all if current_company_operator.admin?
  end

  def show
    @company_operator = CompanyOperator.find(params[:id])

    redirect_to company_operators_path, alert: 'Access denied.' unless current_company_operator.admin? && @company_operator == current_company_operator
  end

  def update
    @company_operator = CompanyOperator.find(params[:id])
    if @company_operator.update_attributes(secure_params)
      redirect_to company_operators_path, notice: 'User updated.'
    else
      redirect_to company_operator_path, alert: 'Unable to update user.'
    end
  end

  def destroy
    @company_operator = CompanyOperator.find(params[:id])

    redirect_to(company_operators_path, alert: 'Action denied.') && return unless current_company_operator.admin? && @company_operator == current_company_operator

    company_operator.destroy
    redirect_to company_operators_path, notice: 'User deleted.'
  end

  private

  def secure_params
    # We need to pull the params and handle company_operator as well maybe?

    params.require(:company_operator).permit(:role)
  end
end
