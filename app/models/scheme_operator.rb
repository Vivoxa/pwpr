class SchemeOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_and_belongs_to_many :schemes
  validates_presence_of :schemes
  include CommonHelpers::PermissionsHelper

  PERMISSIONS = CommonHelpers::PermissionsHelper::SHARED_SO_ADMIN_PERMISSIONS
  ROLES = %w(sc_director sc_super_user sc_user).freeze
  royce_roles ROLES + PERMISSIONS

  scope :company_operators, -> (scheme) { scheme.company_operators }
  scope :pending_scheme_operators, -> { where('confirmed_at <= NOW()') }

  after_create :assign_roles

  private

  def assign_roles
    add_role :sc_user
    add_role :sc_users_r
    add_role :businesses_r
    add_role :schemes_r
  end
end
