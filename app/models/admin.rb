class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseInvitable::Inviter

  royce_roles PermissionsForRole::Admin::ROLES + PermissionsForRole::Admin::PERMISSIONS

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
    PermissionsForRole::Admin::permissions_for_role(:restricted_admin).each do |permission|
      add_role permission
    end
  end
end
