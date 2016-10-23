class SchemeOperatorsController < BaseController
  before_filter :authenticate_scheme_operator
  load_and_authorize_resource

  # GET /scheme_operators
  def index
    # TODO: this needs scoping to a scheme
    @scheme_operators = current_user.schemes.each.map{ |scheme| scheme.scheme_operators }.flatten
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
    update_operator(@scheme_operator, secure_params, scheme_operators_path)
  end

  # DELETE /scheme_operators/:id
  def destroy
    destroy_operator(@scheme_operator, scheme_operators_path)
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

    modify_roles_and_permissions(scheme_operator_path(@user.id))
  end

  private

  def secure_params
    # We need to pull the params and handle company_operator as well maybe?
    params.require(:scheme_operator).permit(:role, :name, :email)
  end
end
