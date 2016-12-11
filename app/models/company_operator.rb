class CompanyOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  royce_roles PermissionsForRole::CompanyOperatorDefinitions::ROLES + PermissionsForRole::CompanyOperatorDefinitions::PERMISSIONS

  belongs_to :business

  validates_presence_of :business, :first_name, :last_name

  # scope :active, -> { where(approved: true) }
  # scope :pending, -> { where(approved: false) }

  after_create :assign_roles

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    :not_approved unless approved?
  end

  private

  def assign_roles
    logger.tagged('CompanyOperator(M)') do
      logger.info "assign_roles() - adding co_user permissions to new CompanyOperator with email: #{email}"
      add_role :co_user
      permission_helper = PermissionsForRole::CompanyOperatorDefinitions.new
      permission_helper.assign_mandatory_permissions_for_role!(self, :co_user)
    end
  end
end
