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
    removed_roles = Admin::ROLES - [params[:role]] + Admin::PERMISSIONS - params[:permissions]
    current_roles = @user.role_list

    begin
      # Remove deselected roles
      removed_roles.each do |r|
        @user.remove_role r if r
      end

      # Add role
      @user.add_role params[:role] if params[:role]

      permissions = params[:permissions] ? params[:permissions] : []

      # Add roles for permissions
      permissions.each do |p|
        @user.add_role p if p
      end
    rescue
      # Roll back roles
      current_roles.each do |r|
        @user.add_role r
      end

      redirect_to admin_path @user.id, error: "An error occured! User #{@user.email}'s permissions were not updated.", status: :unprocessable_entity # 422
      return
    end

    redirect_to admin_path @user.id, notice: 'Permissions updated succesfully!', status: :ok # 302
  end

  private

  def secure_params
    # We need to pull the params for the correct "user"

    # params.require(:admin).permit(:role)
  end
end
