module PermissionsForRole
  module Role
    class CompanyOperatorAbility < BaseAbility
      include CanCan::Ability

      def initialize(user)
        super(user)
        can %i(read edit update update_permissions), CompanyOperator, id: user.business.company_operator_ids if user.co_users_e?
        can %i(read destroy update_permissions), CompanyOperator, id: user.business.company_operator_ids if user.co_users_d?

        if user.co_users_r?
          can :pending, CompanyOperator
          can :invited_not_accepted, CompanyOperator
          can %i(read permissions), CompanyOperator, id: user.business.company_operator_ids
        end

        # permissions for Business
        can :read, Business, id: user.business_id if user.businesses_r?
        can %i(edit update), Business, id: user.business_id if user.businesses_e?

        # Invitations and creating new Company Operators
        if user.co_users_w?
          can :read, BaseInvitationsController
          can %i(new create), BaseInvitationsController
          can %i(edit update), BaseInvitationsController

          can :read, BaseRegistrationsController
          can %i(new create), BaseRegistrationsController
          can %i(edit update), BaseRegistrationsController

          can %i(new create), CompanyOperators::InvitationsController

          can %i(read new create update_permissions), CompanyOperator
        end
      end
    end
  end
end
