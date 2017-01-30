class SchemeOperatorsController < BaseController
  before_filter :authenticate_scheme_operator
  before_filter :authorize_permissions, only: :permissions
  before_filter :authorize_update_permissions, only: :update_permissions
  load_and_authorize_resource

  # GET /scheme_operators
  def index
    # TODO: this needs scoping to a scheme
    @schemes = scheme_operators_by_approved(true)
  end

  def pending
    @schemes = pending_operators(scheme_operators_by_approved(false))
  end

  # GET /scheme_operators/:id
  def show
    # We need to figure a scope to search for users dynamically based on the category
    # in order to be able to search for the one clicked on in the right table
    @scheme_operator = SchemeOperator.find(params[:id])
  end

  # GET /scheme_operators/1/edit
  def edit; end

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

  def invited_not_accepted
    query = 'invitation_sent_at IS NOT NULL AND invitation_accepted_at IS NULL'
    @schemes = {}
    current_user.schemes.each do |scheme|
      @schemes[scheme.id] = {users: scheme.scheme_operators.where(query), name: scheme.name}
    end
  end

  private

  def authorize_permissions
    authorize! :permissions, SchemeOperator.find(params['scheme_operator_id'].to_i)
  end

  def authorize_update_permissions
    authorize! :update_permissions, SchemeOperator.find(params['scheme_operator_id'].to_i)
  end

  def pending_operators(schemes)
    schemes.each do |_scheme_id, details|
      details[:users].each do |user|
        pending_operators = []
        pending_operators << user if user.confirmed_at.present?
        details[:users] = pending_operators
      end
    end
    schemes
  end

  def scheme_operators_by_approved(approved = true)
    if current_scheme_operator || current_admin
      schemes = {}
      current_user.schemes.each do |scheme|
        schemes[scheme.id] = {users: (scheme.scheme_operators.where(approved: approved).order(:last_name) - [current_user]), name: scheme.name}
      end
      schemes
    end
  end

  def secure_params
    # We need to pull the params and handle company_operator as well maybe?
    params.require(:scheme_operator).permit(:role, :first_name, :email, :approved, :last_name)
  end
end
