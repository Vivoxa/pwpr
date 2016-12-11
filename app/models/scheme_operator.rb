class SchemeOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  include CommonHelpers::PermissionsHelper

  royce_roles PermissionsForRole::SchemeOperatorDefinitions::ROLES + PermissionsForRole::SchemeOperatorDefinitions::PERMISSIONS
  has_and_belongs_to_many :schemes
  validates_presence_of :schemes, :first_name, :last_name

  scope :company_operators, ->(scheme) { scheme.company_operators }
  scope :pending_scheme_operators, -> { where('confirmed_at <= NOW()') }

  after_create :assign_roles

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    :not_approved unless approved?
  end

  private

  def assign_roles
    logger.tagged('SchemeOperator(M)') do
      logger.info "assign_roles() - adding sc_user permissions to new SchemeOperator with email: #{email}"
      add_role :sc_user
      permission_helper = PermissionsForRole::SchemeOperatorDefinitions.new
      permission_helper.assign_mandatory_permissions_for_role!(self, :sc_user)
    end
  end
end
