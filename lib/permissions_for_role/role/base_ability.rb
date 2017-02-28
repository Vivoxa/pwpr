module PermissionsForRole
  module Role
    class BaseAbility
      include CanCan::Ability

      def initialize(user)
        can :manage, VisitorsController
      end

      def scheme_operator_ids_for_associated_schemes(user)
        ids = user.schemes.where(active: true).each.map(&:scheme_operator_ids).flatten
        ids.reject!{ |id| id == user.id } if user.is_a?(SchemeOperator)
        ids.flatten
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

      def associated_contact_ids_for_user(user)
        business_ids = associated_business_ids_for_associated_schemes(user)
        contact_ids = []
        Business.where(id: business_ids).each do |business|
          contact_ids << business.contact_ids
        end
        contact_ids.flatten
        contact_ids.reject!{ |id| id == user.id } if user.is_a?(CompanyOperator)
        contact_ids.flatten
      end

      def associated_business_ids_for_associated_schemes(user)
        business_ids = []
        user.schemes.each do |scheme|
          business_ids << scheme.business_ids if scheme.active
        end
        business_ids.flatten
      end

      def associated_material_detail_ids_for_businesses(user)
        business_ids = associated_business_ids_for_associated_schemes(user)
        material_detail_ids = []

        Business.where(id: business_ids).each do |business|
           business.registrations.each do |registration|
            registration.regular_producer_detail&.first&.material_details&.each do |material_detail|
              material_detail_ids << material_detail.id
            end
          end
        end
        material_detail_ids.flatten
      end

      def associated_regular_producer_ids_for_businesses(user)
        business_ids = associated_business_ids_for_associated_schemes(user)
        regular_producer_ids = []

        Business.where(id: business_ids).each do |business|
          regular_producer_ids << business.registrations&.first&.regular_producer_detail&.id
        end
        regular_producer_ids.flatten
      end

      def associated_small_producer_ids_for_businesses(user)
        business_ids = associated_business_ids_for_associated_schemes(user)
        small_producer_ids = []

        Business.where(id: business_ids).each do |business|
          small_producer_ids << business.registrations&.small_producer_detail&.id
        end
        small_producer_ids.flatten
      end
    end
  end
end
