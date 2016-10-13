class PermissionsController < ApplicationController
  before_action :authenticate_admin!
  # load_and_authorize_resource <<<<<< this fails for some reason...

  def show
    # current_user is not correct here
    @roles = current_user.user_roles
    @permissions = current_user.user_permissions
  end

  def add_role_and_permissions
    permissions = params[:permissions]

    # add role
    current_user.add_role params[:role]

    # add permissions
    permissions.each do |permission|
      current_user.add_role permission
    end
  end
end
