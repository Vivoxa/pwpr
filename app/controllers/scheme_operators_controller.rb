class SchemeOperatorsController < ApplicationController
  before_filter :authenticate_scheme_operator
  load_and_authorize_resource

  def index
    # TODO: this needs scoping to a scheme
    @scheme_operators = SchemeOperator.all
  end

  def show
    # We need to figure a scope to search for users dynamically based on the category
    # in order to be able to search for the one clicked on in the right table
    @scheme_operator = SchemeOperator.find(params[:id])
  end

  def update
    @scheme_operator = SchemeOperator.find(params[:id])
    @scheme_operator.update_attributes(secure_params)
  end

  def destroy
    @scheme_operator = SchemeOperator.find(params[:id])
    @scheme_operator.destroy
  end

  def permissions
    @user = SchemeOperator.find_by_id(params[:id])
    @available_roles = SchemeOperator::ROLES
    @available_permissions = SchemeOperator::PERMISSIONS
  end

  def update_permissions
    @user = SchemeOperator.find_by_id(params[:id])

    begin
      # Add role
      @user.add_role params[:role]

      permissions = params[:permissions] # This should be and array/hash of selected permissions

      # Add roles for permissions
      permissions.each do |p|
        @user.add_role p
      end
    rescue
      redirect_to scheme_operator_show_path, error: "An error occured! User #{@user.email}'s permissions were not updated.", status: :unprocessable_entity # 422
    end

    redirect_to scheme_operator_show_path @user.id, notice: 'Permissions updated succesfully!', status: :ok # 200 if
  end

  private

  def secure_params
    # We need to pull the params and handle company_operator as well maybe?

    params.require(:scheme_operator).permit(:role)
  end
end
