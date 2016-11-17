module PermissionsForRole
  class BaseDefinitions
    def assign_default_permissions_for_role!(user, role)
      permissions_for_role(role.to_sym).each do |permission, can_have|
        user.add_role permission if can_have[:checked]
      end
    end

    def permissions_for_role(_role)
      raise NotImplementedError
    end
  end
end
