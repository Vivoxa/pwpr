module PermissionsForRole
  module Role
    class AdminAbility < SharedAdminScAbility
      include CanCan::Ability

      def initialize(user)
        super(user)
        admin_permissions(user)
        super_admin_permissions(user)
        registration_data_permissions(user)
        business_permissions(user)
        scheme_permissions(user)
        contact_permissions(user)
      end

      def super_admin_permissions(user)
        can %i(read new create update destroy), Admins::RegistrationsController if user.super_admin?
      end

      def admin_permissions(user)
        can %i(read permissions), Admin if user.admins_r?
        can %i(read edit update permissions update_permissions approve), Admin if user.admins_e?
        can %i(read destroy permissions update_permissions approve), Admin if user.admins_d?
        if user.admins_w?
          can %i(read new create permissions update_permissions approve), Admin
          can %i(read new create edit update), Admins::RegistrationsController
        end
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

      def business_permissions(user)
        can %i(read scheme_businesses), Business if user.businesses_r?
        can %i(new create scheme_businesses), Business if user.businesses_w?
        can %i(edit update scheme_businesses), Business if user.businesses_e?
        can :destroy, Business if user.businesses_d?
      end

      def contact_permissions(user)
        can :read, Contact if user.contacts_r?
        can %i(new create), Contact if user.contacts_w?
        can %i(edit update), Contact if user.contacts_e?
        can :destroy, Contact if user.contacts_d?
      end

      def scheme_permissions(user)
        can :read, Scheme, id: user.scheme_ids if user.schemes_r?
        can %i(new create), Scheme if user.schemes_w?
        can %i(edit update), Scheme, id: user.scheme_ids if user.schemes_e?
        can :destroy, Scheme, id: user.scheme_ids if user.schemes_d?
      end
    end
  end
end
