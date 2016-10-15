class CompanyOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  ROLES = %w(co_director co_contact co_user)
  PERMISSIONS = %w(co_user_r co_user_rw co_user_rwe)
  royce_roles ROLES + PERMISSIONS

  belongs_to :scheme

  scope :scheme_operators, -> (scheme) { scheme.scheme_operators }
end
