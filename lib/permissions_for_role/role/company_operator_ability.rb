module PermissionsForRole
  module Role
    class CompanyOperatorAbility < BaseAbility
      include CanCan::Ability

      def initialize(user)
        super(user)
        can %i(read edit update permissions update_permissions), CompanyOperator, id: user.business.company_operator_ids if user.co_users_e?
        can %i(read destroy), CompanyOperator, id: user.business.company_operator_ids if user.co_users_d?

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

          can %i(read new create edit update update_businesses), CompanyOperators::InvitationsController

          can %i(read new create permissions update_permissions), CompanyOperator
        end
      end
    end
  end
end
