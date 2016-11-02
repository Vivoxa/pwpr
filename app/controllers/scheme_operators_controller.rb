class SchemeOperatorsController < BaseController
  before_filter :authenticate_scheme_operator
  load_and_authorize_resource

  # GET /scheme_operators
  def index
    # TODO: this needs scoping to a scheme
    @scheme_operators = current_user.schemes.each.map(&:scheme_operators).flatten
  end

  def invited_not_accepted
    query = 'invitation_sent_at IS NOT NULL AND invitation_accepted_at IS NULL'
    @scheme_operators = []
    current_user.schemes.each do |scheme|
      scheme.scheme_operators.where(query).each do |scheme_operator|
        @scheme_operators << scheme_operator
      end
    end
  end

  # GET /scheme_operators/:id
  def show
    # We need to figure a scope to search for users dynamically based on the category
    # in order to be able to search for the one clicked on in the right table
    @scheme_operator = SchemeOperator.find(params[:id])
  end

  # GET /scheme_operators/1/edit
  def edit
  end

  # PATCH/PUT /scheme_operators/:id
  def update
    update_object(@scheme_operator, scheme_operators_path, secure_params)
  end

  # DELETE /scheme_operators/:id
  def destroy
    destroy_operator(@scheme_operator, scheme_operators_path)
  end

  # GET /scheme_operators/:id/permissions
  def permissions
    @user = SchemeOperator.find_by_id(params[:scheme_operator_id])

    @available_roles = PermissionsForRole::SchemeOperatorDefinitions::ROLES
    @available_permissions = PermissionsForRole::SchemeOperatorDefinitions::PERMISSIONS

    current_role = @user.role_list & @available_roles
    @permissions_definitions = PermissionsForRole::SchemeOperatorDefinitions.new

    # This needs to somehow dynamically reload when the selected role is changed in the UI
    @allowed_permissions = @permissions_definitions.permissions_for_role(current_role.first)
  end

  # PUT /scheme_operators/:id/update_permissions
  def update_permissions
    @user = SchemeOperator.find_by_id(params[:scheme_operator_id])
    @available_roles = PermissionsForRole::SchemeOperatorDefinitions::ROLES
    @definitions = PermissionsForRole::SchemeOperatorDefinitions.new

    modify_roles_and_permissions(scheme_operator_path(@user.id))
  end

  private

  def secure_params
    # We need to pull the params and handle company_operator as well maybe?
    params.require(:scheme_operator).permit(:role, :name, :email)
  end
end
