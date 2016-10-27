module PermissionsForRole
  class Admin
    # include PermissionsForRole::SharedPermissions::SHARED_PERMISSIONS
    ROLES = %w(super_admin normal_admin restricted_admin).freeze
    PERMISSIONS = PermissionsForRole::SharedPermissions::SHARED_PERMISSIONS

    def permissions_for_role(role)

    end

    def super_admin
      {}
    end
  end
end
