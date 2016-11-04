module PermissionsForRole
  module Role
    class VisitorAbility
      include CanCan::Ability

      def initialize(_user)
        can :manage, VisitorsController
        can %i(edit update), BaseInvitationsController
        can %i(edit update), SchemeOperators::InvitationsController
        can %i(edit update), CompanyOperators::InvitationsController
      end
    end
  end
end
