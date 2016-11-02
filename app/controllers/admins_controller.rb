class AdminsController < BaseController
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

  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  def update
    update_object(@admin, admins_url, secure_params)
  end

  # GET /admins/:id/permissions
  def permissions
    @user = Admin.find_by_id(params[:admin_id])
    @available_roles = PermissionsForRole::AdminDefinitions::ROLES
    @available_permissions = PermissionsForRole::AdminDefinitions::PERMISSIONS

    current_role = @user.role_list & @available_roles
    @permissions_definitions = PermissionsForRole::AdminDefinitions.new

    # This needs to somehow dynamically reload when the selected role is changed in the UI
    @allowed_permissions = @permissions_definitions.permissions_for_role(current_role.first)
  end

  # GET /admins/:id/permissions
  def update_permissions
    @user = Admin.find_by_id(params[:admin_id])

    modify_roles_and_permissions(admin_path(@user.id))
  end

  private

  def secure_params
    # We need to pull the params for the correct "user"

    params.require(:admin).permit(:role, :name, :email)
  end
end
