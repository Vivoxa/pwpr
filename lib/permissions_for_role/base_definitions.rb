module PermissionsForRole
  class BaseDefinitions
    include Logging

    def assign_mandatory_permissions_for_role!(user, role)
      permissions_for_role(role.to_sym).each do |permission, should_have|
        user.add_role permission if should_have[:checked] && should_have[:locked]
      end
    end

    def permissions_for_role(_role)
      raise NotImplementedError
    end
  end
end
