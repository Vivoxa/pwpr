module PermissionsForRole
  module Role
    class AdminAbility < SharedAdminScAbility
      include CanCan::Ability

      def initialize(user)
        super(user)
        can %i(read permissions), Admin if user.admins_r?
        can %i(read new create permissions update_permissions approve), Admin if user.admins_w?
        can %i(read edit update permissions update_permissions approve), Admin if user.admins_e?
        can %i(read destroy permissions update_permissions approve), Admin if user.admins_d?
        if user.admins_w?
          can %i(read new create permissions update_permissions approve), Admin
          can %i(new create edit update), Admins::RegistrationsController
        end

        can %i(read new create update destroy), Admins::RegistrationsController if user.super_admin?
        email_name_permissions(user)
        email_content_type_permissions(user)
      end

      def business_permissions(user)
        can :read, Business if user.businesses_r?
        can %i(new create), Business if user.businesses_w?
        can %i(edit update), Business if user.businesses_e?
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

      def email_name_permissions(user)
        can :read, EmailName if user.email_names_r?
        can %i(new create), EmailName if user.email_names_w?
        can %i(edit update), EmailName if user.email_names_e?
        can :destroy, EmailName if user.email_names_d?
      end

      def email_content_type_permissions(user)
        can :read, EmailContentType if user.email_content_types_r?
        can %i(new create), EmailContentType if user.email_content_types_w?
        can %i(edit update), EmailContentType if user.email_content_types_e?
        can :destroy, EmailContentType if user.email_content_types_d?
      end
    end
  end
end
