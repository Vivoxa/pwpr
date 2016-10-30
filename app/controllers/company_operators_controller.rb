class CompanyOperatorsController < BaseController
  before_action :authenticate_company_operator
  load_and_authorize_resource
  include CommonHelpers::BusinessDropdownHelper
  respond_to :js

  # GET /company_operators
  # TODO: requires scoping
  def index
    @company_operators = company_operators_by_approved(true)
  end

  def pending
    @company_operators = pending_company_operators
  end

  def invited_not_accepted
    @company_operators = unaccepted_invitations
  end

  # GET /company_operators/:id
  def show
    @company_operator = CompanyOperator.find(params[:id])
  end

  # GET /company_operators/1/edit
  def edit
  end

  # PATCH/PUT /company_operators/:id
  def update
    update_object(@company_operator, company_operators_path, secure_params)
  end

  # DELETE /company_operators/:id
  def destroy
    destroy_operator(@company_operator, company_operators_path)
  end

  # GET /company_operators/:id/permissions
  def permissions
    @user = CompanyOperator.find_by_id(params[:company_operator_id])
    @available_roles = PermissionsForRole::CompanyOperator::ROLES
    @available_permissions = PermissionsForRole::CompanyOperator::permissions_for_role(@user)
  end

  # GET /company_operators/:id/permissions
  def update_permissions
    @user = CompanyOperator.find_by_id(params[:company_operator_id])

    modify_roles_and_permissions(company_operator_path(@user.id))
  end

  private

  def company_operators_by_approved(approved = true)
    if current_scheme_operator || current_admin
      company_operators = []
      current_user.schemes.each do |scheme|
        scheme.businesses.each do |business|
          company_operators << business.company_operators.where(approved: approved)
        end
      end
      company_operators.flatten
    else
      current_user.business.company_operators.where(approved: approved)
    end
  end

  def pending_company_operators
    pending = company_operators_by_approved(false)
    pending_company_operators = []
    pending.each do |co|
      pending_company_operators << co if co.confirmed_at.present?
    end
    pending_company_operators
  end

  def unaccepted_invitations
    company_operators = []
    company_operators_by_approved(false).each do |company_operator|
      company_operators << company_operator if invitation_sent_not_accepted?(company_operator)
    end
    company_operators
  end

  def invitation_sent_not_accepted?(company_operator)
    company_operator.invitation_sent_at.present? && company_operator.invitation_accepted_at.nil?
  end

  def secure_params
    # We need to pull the params and handle company_operator as well maybe?
    params.require(:company_operator).permit(:role, :name, :email, :approved)
  end
end
