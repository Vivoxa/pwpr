class Abilities
  def self.ability_for(user)
    permissions = if user.is_a?(Admin)
                    PermissionsForRole::Role::AdminAbility.new(user)
                  elsif user.is_a?(Visitor)
                    PermissionsForRole::Role::VisitorAbility.new(user)
                  elsif user.is_a?(SchemeOperator)
                    PermissionsForRole::Role::SchemeOperatorAbility.new(user)
                  elsif user.is_a?(CompanyOperator)
                    PermissionsForRole::Role::CompanyOperatorAbility.new(user)
                  end
    permissions
  end
end
