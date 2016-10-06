# frozen_string_literal: true
class SchemeOperatorsController < ApplicationController
  # before_action :authenticate_scheme_operator!
  # before_action :scheme_operator_and_admin_user_only

  def index
    # Show a categorized list of users based on type (scheme_operator(admins) and company_operator)
  end

  def show
    # We need to figure a scope to search for users dynamically based on the category
    # in order to be able to search for the one clicked on in the right table
    @scheme_operator = SchemeOperator.find(params[:id])

    redirect_to scheme_operators_path, alert: 'Access denied.' unless current_scheme_operator || current_admin && @scheme_operator == current_admin

    redirect_to company_operator_show_path if @company_operator.is_member?
  end

  def update
    @scheme_operator = SchemeOperator.find(params[:id])

    if @scheme_operator.update_attributes(secure_params)
      redirect_to scheme_operator_path, notice: 'User updated.'
    else
      redirect_to scheme_operator_path, alert: 'Unable to update user.'
    end
  end

  def destroy
    @scheme_operator = SchemeOperator.find(params[:id])

    redirect_to(:back, alert: 'Action denied.') && return unless priviledged_user

    @scheme_operator.destroy
    redirect_to scheme_operator_path, notice: 'User deleted.'
  end

  private

  def scheme_operator_and_admin_user_only
    redirect_to scheme_operator_path, alert: 'Access denied.' unless current_scheme_operator || current_admin
  end

  def priviledged_user
    current_admin && current_scheme_operator.admin? && @scheme_operator == current_scheme_operator
  end

  def secure_params
    # We need to pull the params and handle company_operator as well maybe?

    params.require(:scheme_operator).permit(:role)
  end
end
