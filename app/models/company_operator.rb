class CompanyOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  royce_roles %w(co_director co_contact co_user_r co_user_rw co_user_rwe)

  belongs_to :scheme

  scope :scheme_operators, -> (scheme) { scheme.scheme_operators }
end
