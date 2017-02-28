module PermissionsForRole
  module Role
    class SchemeOperatorAbility < SharedAdminScAbility
      include CanCan::Ability

      def initialize(user)
        super(user)

        registration_data_permissions(user)

        business_permissions(user)

        scheme_permissions(user)

        contact_permissions(user)
      end

      def registration_data_permissions(user)
        if user.registration_data_r?
          can :read, MaterialDetail, id: associated_material_detail_ids_for_businesses(user)
          can :read, RegularProducerDetail, id: associated_regular_producer_ids_for_businesses(user)
          can :read, SmallProducerDetail, id: associated_regular_producer_ids_for_businesses(user)
        end
        if user.registration_data_w?
          can %i(new create), MaterialDetail, id: associated_material_detail_ids_for_businesses(user)
          can %i(new create), RegularProducerDetail, id: associated_regular_producer_ids_for_businesses(user)
          can %i(new create), SmallProducerDetail, id: associated_regular_producer_ids_for_businesses(user)
        end
        if user.registration_data_e?
          can %i(edit update), MaterialDetail, id: associated_material_detail_ids_for_businesses(user)
          can %i(edit update), RegularProducerDetail, id: associated_regular_producer_ids_for_businesses(user)
          can %i(edit update), SmallProducerDetail, id: associated_regular_producer_ids_for_businesses(user)
        end
      end

      def scheme_permissions(user)
        active_schemes = []
        user.schemes.each do |scheme|
          active_schemes << scheme.id if scheme.active
        end
        can :read, Scheme, id: active_schemes if user.schemes_r?
      end

      def contact_permissions(user)
        can :read, Contact, id: associated_contact_ids_for_user(user) if user.contacts_r?
        can %i(new create), Contact if user.contacts_w?
        can %i(edit update), Contact, id: associated_contact_ids_for_user(user) if user.contacts_e?
        can :destroy, Contact, id: associated_contact_ids_for_user(user) if user.contacts_d?
      end

      def business_permissions(user)
        can :read, Business, id: associated_business_ids_for_associated_schemes(user) if user.businesses_r?
        can %i(new create), Business if user.businesses_w?
        can %i(edit update), Business, id: associated_business_ids_for_associated_schemes(user) if user.businesses_e?
        #can :destroy, Business, id: associated_business_ids_for_associated_schemes(user) if user.businesses_d?
      end

    end
  end
end
