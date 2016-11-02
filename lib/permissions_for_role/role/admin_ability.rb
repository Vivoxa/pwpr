module PermissionsForRole
  module Role
    class AdminAbility < SharedAdminScAbility
      include CanCan::Ability

      def initialize(user)
        super(user)

        can %i(read new create update_permissions), Admin
        can %i(read edit update update_permissions), Admin if user.admins_e?
        can %i(read destroy update_permissions), Admin if user.admins_d?
        if user.admins_w?
          can %i(new create edit update), Admins::RegistrationsController
          can %i(read permissions), Admin if user.admins_r?
        end
      end
    end
  end
end
