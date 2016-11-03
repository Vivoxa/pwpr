module PermissionsForRole
  module Role
    class AdminAbility < SharedAdminScAbility
      include CanCan::Ability

      def initialize(user)
        super(user)
        can %i(read permissions), Admin if user.admins_r?
        can %i(read new create permissions update_permissions), Admin if user.admins_w?
        can %i(read edit update permissions update_permissions), Admin if user.admins_e?
        can %i(read destroy permissions update_permissions), Admin if user.admins_d?
        if user.admins_w?
          can %i(read new create permissions update_permissions), Admin
          can %i(new create edit update), Admins::RegistrationsController
        end

        can %i(read new create update destroy), Admins::RegistrationsController if user.super_admin?
      end
    end
  end
end
