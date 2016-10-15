class CompanyOperator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  royce_roles %w(co_director co_contact co_user co_user_r co_user_rw co_user_rwe)

  belongs_to :scheme

  scope :scheme_operators, -> (scheme) { scheme.scheme_operators }

  def user_roles
    %w(co_director co_contact co_user)
  end

  def user_permissions
    %w(co_user_r co_user_rw co_user_rwe)
  end
end
