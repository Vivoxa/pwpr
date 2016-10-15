class CompanyOperatorPermissionsController < ApplicationController
  before_filter :authenticate_company_operator
  authorize_resource class: CompanyOperator

  def show
  end

  def update_roles_and_permissions
  end
end
