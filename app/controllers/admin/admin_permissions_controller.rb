class Admin::AdminPermissionsController < ApplicationController
  before_filter :authenticate_admin!
  authorize_resource class: Admin

  def show
    @user = Admin.find_by_id(params[:id])
    @available_roles = user.available_roles - Admin::PERMISSIONS
    @available_permissions = user.available_roles - Admin::ROLES
  end

  def update
    @user = Admin.find_by_id(params[:id])

    begin
      @user.add_role params[:role]

      permissions = params[:permissions] # This should be and array/hash of selected permissions

      permissions.each do |p|
        @user.add_role p
      end
    rescue
      redirect_to admin_show_path, error: "An error occured! User #{@user.email}'s permissions were not updated.", status: :unprocessable_entity # 422
    end

    redirect_to admin_show_path @user.id, notice: 'Permissions updated succesfully!', status: :ok # 200 if
  end
end
