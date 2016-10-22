class SchemeOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  ROLES = %w(sc_director sc_super_user sc_user).freeze
  PERMISSIONS = %w(sc_users_r sc_users_w sc_users_e sc_users_d
                  co_users_r co_users_w co_users_d co_users_e
                  businesses_r businesses_w businesses_d businesses_e
                  schemes_r schemes_w schemes_d schemes_e).freeze
  royce_roles ROLES + PERMISSIONS

  has_and_belongs_to_many :schemes
  validates_presence_of :schemes

  scope :company_operators, -> (scheme) { scheme.company_operators }
  scope :pending_scheme_operators, -> { where('confirmed_at <= NOW()') }
end
