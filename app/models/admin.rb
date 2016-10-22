class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseInvitable::Inviter

  ROLES = %w(super_admin normal_admin restricted_admin).freeze
  PERMISSIONS = %w(sc_users_r sc_users_w sc_users_e sc_users_d
                  co_users_r co_users_w co_users_d co_users_e
                  businesses_r businesses_w businesses_d businesses_e
                  schemes_r schemes_w schemes_d schemes_e).freeze
  royce_roles ROLES + PERMISSIONS

  def schemes
    Scheme.all
  end
end
