module PermissionsForRole
  module Role
    class SchemeOperatorAbility < SharedAdminScAbility
      include CanCan::Ability

      def initialize(user)
        super(user)
      end
    end
  end
end
