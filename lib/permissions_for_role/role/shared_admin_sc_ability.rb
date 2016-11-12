module PermissionsForRole
  module Role
    class SharedAdminScAbility < BaseAbility
      include CanCan::Ability

      def initialize(user)
        super(user)
        sc_users_r(user)
        sc_users_w(user)
        sc_users_e(user)
        sc_users_d(user)
        
        can %i(new create), AgencyTemplateUpload if user.uploads_w?
        can :read, AgencyTemplateUpload if user.uploads_r?
        # permissions for Company Operator
        can %i(edit update permissions update_permissions), CompanyOperator, id: company_operator_ids_for_associated_schemes(user) if user.co_users_e?

        if user.co_users_d?
          can :destroy, CompanyOperator, id: company_operator_ids_for_associated_schemes(user)
          can :destroy, CompanyOperators::RegistrationsController
        end

        co_users_r(user)
        co_users_w(user)

        # permissions for Business
        business_permissions(user)

        # permissions for Scheme
        scheme_permissions(user)
      end

      def scheme_permissions(user)
        active_schemes = []
        user.schemes.each do |scheme|
          active_schemes << scheme.id if scheme.active
        end
        can :read, Scheme, id: active_schemes if user.schemes_r?
        can %i(new create), Scheme if user.schemes_w?
        can %i(edit update), Scheme, id: active_schemes if user.schemes_e?
        can :destroy, Scheme, id: active_schemes if user.schemes_d?
      end


      def business_permissions(user)
        can :read, Business, id: associated_business_ids_for_associated_schemes(user) if user.businesses_r?
        can %i(new create), Business if user.businesses_w?
        can %i(edit update), Business, id: associated_business_ids_for_associated_schemes(user) if user.businesses_e?
        can :destroy, Business, id: associated_business_ids_for_associated_schemes(user) if user.businesses_d?
      end

      def co_users_w(user)
        return unless user.co_users_w?
        can :read, BaseInvitationsController
        can %i(new create), BaseInvitationsController
        can %i(edit update), BaseInvitationsController

        can :read, BaseRegistrationsController
        can %i(new create), BaseRegistrationsController
        can %i(edit update), BaseRegistrationsController

        can %i(new create), CompanyOperators::InvitationsController

        can %i(new create permissions update_permissions), CompanyOperator
      end

      def co_users_r(user)
        if user.co_users_r?
          can :pending, CompanyOperator
          can :invited_not_accepted, CompanyOperator
          can %i(read permissions), CompanyOperator, id: company_operator_ids_for_associated_schemes(user)
        end
      end

      def sc_users_w(user)
        if user.sc_users_w?
          can :read, BaseInvitationsController
          can %i(new create), BaseInvitationsController
          can %i(edit update), BaseInvitationsController

          can :read, BaseRegistrationsController
          can %i(new create), BaseRegistrationsController
          can %i(edit update), BaseRegistrationsController

          can %i(new create), SchemeOperators::InvitationsController

          can %i(new create), SchemeOperator
          can %i(read permissions update_permissions), SchemeOperator, id: scheme_operator_ids_for_associated_schemes(user)
        end
      end

      def sc_users_r(user)
        return unless user.sc_users_r?
        can :pending, SchemeOperator
        can :invited_not_accepted, SchemeOperator
        can %i(read permissions), SchemeOperator, id: scheme_operator_ids_for_associated_schemes(user)
      end

      def sc_users_e(user)
        return unless user.sc_users_e?
        can %i(edit update), SchemeOperator, id: scheme_operator_ids_for_associated_schemes(user)
      end

      def sc_users_d(user)
        if user.sc_users_d?
          can :destroy, SchemeOperator, id: scheme_operator_ids_for_associated_schemes(user)
          can :destroy, BaseRegistrationsController
          can :destroy, CompanyOperators::RegistrationsController
          can :destroy, BaseInvitationsController
        end
      end
    end
  end
end
