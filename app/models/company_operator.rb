class CompanyOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  royce_roles PermissionsForRole::CompanyOperatorDefinitions::ROLES + PermissionsForRole::CompanyOperatorDefinitions::PERMISSIONS

  belongs_to :business

  validates_presence_of :business

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
    add_role :co_user
    add_role :co_users_r
  end
end
