class CompanyOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  royce_roles %w(co_director co_contact co_user_r co_user_rw co_user_rwe)
  validates_presence_of :business

  belongs_to :business
  # this scope is no longer relevant due to the change in relationship to schemes
  # scope :scheme_operators, -> (scheme) { scheme.scheme_operators }
end
