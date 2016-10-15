class SchemeOperatorPermissionsController < ApplicationController
  before_filter :authenticate_scheme_operator
  authorize_resource class: SchemeOperator

  def show
  end

  def update_roles_and_permissions
  end
end
