
class CompanyOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  royce_roles %w(company_owner company_full_access company_user_r company_user_rw )

  attr_accessor :name

  belongs_to :scheme

  scope :scheme_operators, -> scheme { scheme.scheme_operators }
end
