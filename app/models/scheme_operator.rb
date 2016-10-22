class SchemeOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  ROLES = %w(sc_director sc_super_user sc_user).freeze
  PERMISSIONS = %w(sc_user_r sc_user_w sc_user_e sc_user_d
                  co_user_r co_user_w co_user_d co_user_e
                  businesses_r businesses_w businesses_d businesses_e
                  schemes_r schemes_w schemes_d schemes_e).freeze
  royce_roles ROLES + PERMISSIONS

  has_and_belongs_to_many :schemes
  validates_presence_of :schemes

  scope :company_operators, -> (scheme) { scheme.company_operators }
  scope :pending_scheme_operators, -> { where('confirmed_at <= NOW()') }
end
