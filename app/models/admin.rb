class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseInvitable::Inviter

  ROLES = %w(super_admin normal_admin restricted_admin).freeze
  PERMISSIONS = %w(sc_user_r sc_user_w sc_user_e sc_user_d
                  co_user_r co_user_w co_user_d co_user_e
                  businesses_r businesses_w businesses_d businesses_e
                  schemes_r schemes_w schemes_d schemes_e).freeze
  royce_roles ROLES + PERMISSIONS

  def schemes
    Scheme.all
  end
end
