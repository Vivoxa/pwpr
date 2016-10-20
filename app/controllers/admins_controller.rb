class AdminsController < ApplicationController
  before_action :authenticate_admin!
  load_and_authorize_resource

  # GET /admins
  def index
    # Show a categorized list of users based on type (scheme and member)
    @admins = Admin.all
    @scheme_operators = SchemeOperator.all
    @company_operators = CompanyOperator.all
  end

  # GET /admins/:id
  def show
    # We need to figure a scope to search for users dynamically based on the category
    # in order to be able to search for the one clicked on in the right table
    # @user = User.find(params[:id])

    # redirect_to admins_path, :alert => "Access denied." unless current_admin && @user == current_admin

    # We also need to redirect to the clicked user show action on the relevant controller (scheme or member)
  end

  # GET /admins/:id/permissions
  def permissions
    @user = Admin.find_by_id(params[:admin_id])
    @available_roles = Admin::ROLES
    @available_permissions = Admin::PERMISSIONS
  end

  # GET /admins/:id/permissions
  def update_permissions
    @user = Admin.find_by_id(params[:admin_id])

    modify_roles_and_permissions
  end

  private

  def secure_params
    # We need to pull the params for the correct "user"

    # params.require(:admin).permit(:role)
  end
end
