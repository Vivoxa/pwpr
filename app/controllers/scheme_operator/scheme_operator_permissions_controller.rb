class SchemeOperator::SchemeOperatorPermissionsController < ApplicationController
  before_filter :authenticate_scheme_operator
  authorize_resource class: SchemeOperator

  def show
    @user = SchemeOperator.find_by_id(params[:id])
    @available_roles = SchemeOperator::ROLES
    @available_permissions = SchemeOperator::PERMISSIONS
  end

  def update
    @user = SchemeOperator.find_by_id(params[:id])

    begin
      @user.add_role params[:role]

      permissions = params[:permissions] # This should be and array/hash of selected permissions

      permissions.each do |p|
        @user.add_role p
      end
    rescue => e
      redirect_to scheme_operator_show_path, error: "An error occured! User #{@user.email}'s permissions were not updated.", status: :unprocessable_entity # 422
    end

    redirect_to scheme_operator_show_path @user.id, notice: 'Permissions updated succesfully!', status: :ok # 200 if
  end
end
