module PermissionsForRole
  module Role
    class BaseAbility
      include CanCan::Ability

      def initialize(user)
        can :manage, VisitorsController
      end

      def scheme_operator_ids_for_associated_schemes(user)
        user.schemes.where(active: true).each.map(&:scheme_operator_ids).flatten
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
        business_ids = []
        user.schemes.each do |scheme|
          business_ids << scheme.business_ids if scheme.active
        end
        business_ids.flatten
      end
    end
  end
end
