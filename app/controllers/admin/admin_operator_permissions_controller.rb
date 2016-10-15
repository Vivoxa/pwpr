class AdminOperatorPermissionsController < ApplicationController
  before_filter :authenticate_admin!
  authorize_resource class: AdminOperator

  def show
  end

  def update_roles_and_permissions
  end
end
