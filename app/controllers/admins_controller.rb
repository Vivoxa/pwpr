# frozen_string_literal: true
class AdminsController < ApplicationController
  # before_action :authenticate_admin!
  # before_action :admin_only

  def index
    # Show a categorized list of users based on type (scheme and member)
    @admins = Admin.all
    @scheme_operators = SchemeOperator.all
    @company_operators = CompanyOperator.all
  end

  def show
    # We need to figure a scope to search for users dynamically based on the category
    # in order to be able to search for the one clicked on in the right table
    # @user = User.find(params[:id])

    # redirect_to admins_path, :alert => "Access denied." unless current_admin && @user == current_admin

    # We also need to redirect to the clicked user show action on the relevant controller (scheme or member)
  end

  private

  def admin_only
    redirect_to admins_path, alert: 'Access denied.' unless current_admin
  end

  def secure_params
    # We need to pull the params for the correct "user"

    # params.require(:admin).permit(:role)
  end
end
