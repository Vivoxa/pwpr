module PermissionsForRole
  module Role
    class BaseAbility
      include CanCan::Ability

      def initialize(_user)
        can :manage, VisitorsController
      end

      def scheme_operator_ids_for_associated_schemes(user)
        user.schemes.each.map(&:scheme_operator_ids).flatten
      end

      def company_operator_ids_for_associated_schemes(user)
        company_operator_associated_ids = []
        user.schemes.each do |scheme|
          scheme.businesses.each do |business|
            company_operator_associated_ids << business.company_operator_ids
          end
        end
        company_operator_associated_ids.flatten
      end

      def associated_business_ids_for_associated_schemes(user)
        user.schemes.map(&:business_ids).flatten
      end
    end
  end
end
