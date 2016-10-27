class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Visitor.new

    configure_scheme_operator_and_admin(user) if user.is_a?(SchemeOperator) || user.is_a?(Admin)

    can :manage, VisitorsController

    configure_company_operator(user) if user.is_a?(CompanyOperator)
    configure_admin_only(user) if user.is_a?(Admin)
    configure_visitor if user.is_a?(Visitor)
  end

  private

  ####################################################################################################
  #                                       Admins
  ####################################################################################################

  def configure_admin_only(user)
    can %i(read permissions), Admin if user.admins_r?
    can %i(read new create update_permissions), Admin if user.admins_w?
    can %i(read edit update update_permissions), Admin if user.admins_e?
    can %i(read destroy update_permissions), Admin if user.admins_d?
  end

  ####################################################################################################
  #                                  Company Operators
  ####################################################################################################

  def configure_company_operator(user)
    # permissions for Company Operator
    can %i(read permissions), CompanyOperator, id: user.business.company_operator_ids if user.co_users_r?
    can %i(read new create update_permissions), CompanyOperator if user.co_users_w?
    can %i(read edit update update_permissions), CompanyOperator, id: user.business.company_operator_ids if user.co_users_e?
    can %i(read destroy update_permissions), CompanyOperator, id: user.business.company_operator_ids if user.co_users_d?
    can %i(new create), DeviseOverrides::CompanyOperator::InvitationsController

    # permissions for Business
    can :read, Business, id: user.business_id if user.businesses_r?
    can %i(edit update), Business, id: user.business_id if user.businesses_e?

  def configure_visitor
    can %i(edit update), SchemeOperators::InvitationsController
    can %i(edit update), CompanyOperators::InvitationsController
  end

  def associated_business_ids_for_associated_schemes(user)
    @associated_business_ids ||= user.schemes.map(&:business_ids).flatten
  end

  ####################################################################################################
  #                                  Scheme Operators and Admins
  ####################################################################################################

  def configure_scheme_operator_and_admin(user)
    # retrieve associated ids for Scheme Operator
    configure_operators_for_admin_and_so(user)
    configure_businesss_for_admin_and_so(user)
    configure_scheme_for_admin_and_so(user)
  end

  def configure_operators_for_admin_and_so(user)
    # permissions for Scheme Operator
    can :read, SchemeOperator, id: scheme_operator_ids_for_associated_schemes(user) if user.sc_users_r?
    can %i(new create), SchemeOperator if user.sc_users_w?
    can %i(edit update), SchemeOperator, id: scheme_operator_ids_for_associated_schemes(user) if user.sc_users_e?
    can :destroy, SchemeOperator, id: scheme_operator_ids_for_associated_schemes(user) if user.sc_users_d?

    # permissions for Company Operator
    can :read, CompanyOperator, id: company_operator_ids_for_assocaited_schemes(user) if user.co_users_r?
    can %i(new create), CompanyOperator if user.co_users_w?
    can %i(edit update), CompanyOperator, id: company_operator_ids_for_assocaited_schemes(user) if user.co_users_e?
    can :destroy, SchemeOperator, id: company_operator_ids_for_assocaited_schemes(user) if user.co_users_d?
    can %i(new create), DeviseOverrides::CompanyOperator::InvitationsController
  end

  def configure_businesss_for_admin_and_so(user)
    # permissions for Business
    can :read, Business, id: associated_business_ids_for_associated_schemes(user) if user.businesses_r?
    can %i(new create), Business if user.businesses_w?
    can %i(edit update), Business, id: associated_business_ids_for_associated_schemes(user) if user.businesses_e?
    can :destroy, Business, id: associated_business_ids_for_associated_schemes(user) if user.businesses_d?
  end

  def configure_scheme_for_admin_and_so(user)
    # permissions for Scheme
    can :read, Scheme, id: user.scheme_ids if user.schemes_r?
    can %i(new create), Scheme if user.schemes_w?
    can %i(edit update), Scheme, id: user.scheme_ids if user.schemes_e?
    can :destroy, Scheme, id: user.scheme_ids if user.schemes_d?
  end

  def scheme_operator_ids_for_associated_schemes(user)
    @scheme_associated_so_ids ||= user.schemes.each.map(&:scheme_operator_ids).flatten
  end

  def company_operator_ids_for_assocaited_schemes(user)
    return @company_operator_associated_ids if @company_operator_associated_ids
    company_operator_associated_ids = []
    user.schemes.each do |scheme|
      scheme.businesses.each do |business|
        company_operator_associated_ids << business.company_operator_ids
      end
    end
    @company_operator_associated_ids = company_operator_associated_ids.flatten
  end
end

#   #configure_scheme_operator(user) if user.is_a?(SchemeOperator)

#   configure_company_operator(user) if user.is_a?(CompanyOperator)

#   configure_admin(user) if user.is_a?(Admin)

#   configure_visitor if user.is_a?(Visitor)
# end

# private

# def configure_visitor
#   can %i(edit update), DeviseOverrides::SchemeOperator::InvitationsController
#   can %i(edit update), DeviseOverrides::CompanyOperator::InvitationsController
# end

# def full_access(user)
#   can :read, CompanyOperator, id: user.business.company_operator_ids
#   can :update, CompanyOperator, id: user.business.company_operator_ids
#   can :edit, CompanyOperator, id: user.business.company_operator_ids
#   can %i(new create), CompanyOperator
# end

# def configure_company_operator(user)
#   if user.co_director?
#     can :manage, CompanyOperator, id: user.business.company_operator_ids
#     can %i(new create), CompanyOperator
#     can %i(new create), DeviseOverrides::CompanyOperator::InvitationsController
#   elsif user.co_contact?
#     full_access(user)
#   elsif user.co_user_r?
#     can :read, CompanyOperator, id: user.id
#   elsif user.co_user_rw?
#     can :read, CompanyOperator, id: user.id
#     can :new, CompanyOperator
#     can :create, CompanyOperator
#   elsif user.co_user_rwe?
#     full_access(user)
#   end
# end

# def configure_scheme_operator(user)
#   scheme_associated_so_ids = user.schemes.each.map(&:scheme_operator_ids).flatten
#   company_operator_associated_ids = []
#   user.schemes.each do |scheme|
#     scheme.businesses.each do |business|
#       company_operator_associated_ids << business.company_operator_ids
#     end
#   end
#   company_operator_associated_ids = company_operator_associated_ids.flatten
#   company_operator_associated_ids = [1] if company_operator_associated_ids.empty?

#   if user.sc_director?
#     configure_sc_director(user, scheme_associated_so_ids, company_operator_associated_ids)
#   elsif user.sc_super_user?
#     configure_sc_super_user(user, scheme_associated_so_ids, company_operator_associated_ids)
#   elsif user.sc_user_r?
#     can :read, Scheme, id:  user.schemes.map(&:id)
#     can :read, SchemeOperator
#   elsif user.sc_user_rw?
#     can :read, Scheme, id:  user.schemes.map(&:id)
#     can :read, SchemeOperator
#     can %i(new create), SchemeOperator
#   elsif user.sc_user_rwe?
#     can :read, Scheme, id:  user.schemes.map(&:id)
#     can :read, SchemeOperator
#     can %i(new create update edit), SchemeOperator
#   end
# end

# def configure_sc_super_user(user, scheme_associated_so_ids, company_operator_associated_ids)
#   can :manage, SchemeOperator, id: scheme_associated_so_ids
#   can %i(new create), SchemeOperator
#   cannot :destroy, SchemeOperator
#   can :manage, Scheme, id:  user.scheme_ids
#   can %i(new create), Scheme
#   can :manage, DeviseOverrides::SchemeOperator::InvitationsController
#   can :manage, SchemeOperatorInvitationsController
#   can :manage, DeviseOverrides::RegistrationsController
#   can :manage, CompanyOperator, id: company_operator_associated_ids
#   cannot :destroy, CompanyOperator
#   can %i(new create), CompanyOperator
# end

# def configure_sc_director(user, scheme_associated_so_ids, company_operator_associated_ids)
#   can :manage, SchemeOperator, id: scheme_associated_so_ids
#   can %i(new create), SchemeOperator
#   can :manage, Scheme, id:  user.scheme_ids
#   can %i(new create), Scheme
#   can :manage, DeviseOverrides::RegistrationsController
#   can :manage, DeviseOverrides::SchemeOperator::InvitationsController
#   can :manage, DeviseOverrides::CompanyOperator::InvitationsController
#   can :manage, SchemeOperatorInvitationsController
#   can :manage, CompanyOperator, id: company_operator_associated_ids
#   can %i(new create), CompanyOperator
# end

# def configure_admin(user)
#   if user.full_access?
#     can :manage, Admin
#     can :manage, CompanyOperator
#     can :manage, SchemeOperator
#     can :manage, Scheme
#     can :manage, DeviseOverrides::RegistrationsController
#     can :manage, DeviseOverrides::SchemeOperator::InvitationsController
#     can :manage, DeviseOverrides::CompanyOperator::InvitationsController
#   end
# end

#   user ||= User.new # guest user (not logged in)
#   if user.admin?
#     can :manage, :all
#   else
#     can :read, :all
#   end
#
# The first argument to `can` is the action you are giving the user
# permission to do.
# If you pass :manage it will apply to every action. Other common actions
# here are :read, :create, :update and :destroy.
#
# The second argument is the resource the user can perform the action on.
# If you pass :all it will apply to every resource. Otherwise pass a Ruby
# class of the resource.
#
# The third argument is an optional hash of conditions to further filter the
# objects.
# For example, here the user can only update published articles.
#
#   can :update, Article, :published => true
#
# See the wiki for details:
# https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
