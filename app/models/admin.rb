class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseInvitable::Inviter
  include CommonHelpers::PermissionsHelper
  PERMISSIONS = (%w(admins_r admins_w admins_e admins_d) + CommonHelpers::PermissionsHelper::SHARED_SO_ADMIN_PERMISSIONS).flatten.freeze
  ROLES = %w(super_admin normal_admin restricted_admin).freeze
  royce_roles ROLES + PERMISSIONS

  after_create :assign_roles

  def schemes
    Scheme.all
  end

  def scheme_ids
    schemes.map(&:id)
  end

  private

  def assign_roles
    add_role :restricted_admin
    %i(businesses_r schemes_r sc_users_r co_users_r).each do |permission|
      add_role permission
    end
  end
end
