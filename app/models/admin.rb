class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseInvitable::Inviter

  royce_roles PermissionsForRole::AdminDefinitions::ROLES + PermissionsForRole::AdminDefinitions::PERMISSIONS

  after_create :assign_roles

  def schemes
    Scheme.all
  end

  def scheme_ids
    schemes.map(&:id)
  end

  private

  def assign_roles
    logger.tagged('Admin(M)') do
      logger.info "assign_roles() - adding restricted_admin permissions to new Admin with email: #{email}"
      add_role :restricted_admin
      permission_helper = PermissionsForRole::AdminDefinitions.new
      permission_helper.assign_mandatory_permissions_for_role!(self, :restricted_admin)
    end
  end
end
