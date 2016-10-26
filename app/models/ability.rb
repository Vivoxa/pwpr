class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:

    user ||= Visitor.new

    can :manage, VisitorsController

    configure_scheme_operator(user) if user.is_a?(SchemeOperator)

    configure_company_operator(user) if user.is_a?(CompanyOperator)

    configure_admin(user) if user.is_a?(Admin)

    configure_visitor if user.is_a?(Visitor)
  end

  private

  def configure_visitor
    can %i(edit update), SchemeOperators::InvitationsController
    can %i(edit update), CompanyOperators::InvitationsController
  end

  def full_access(user)
    can :read, CompanyOperator, id: user.business.company_operator_ids
    can :update, CompanyOperator, id: user.business.company_operator_ids
    can :edit, CompanyOperator, id: user.business.company_operator_ids
    can %i(new create), CompanyOperator
  end

  def configure_company_operator(user)
    if user.co_director?
      can :manage, CompanyOperator, id: user.business.company_operator_ids
      can %i(new create), CompanyOperator
      can %i(new create), CompanyOperators::InvitationsController
    elsif user.co_contact?
      full_access(user)
    elsif user.co_user_r?
      can :read, CompanyOperator, id: user.id
    elsif user.co_user_rw?
      can :read, CompanyOperator, id: user.id
      can :new, CompanyOperator
      can :create, CompanyOperator
    elsif user.co_user_rwe?
      full_access(user)
    end
  end

  def configure_scheme_operator(user)
    scheme_associated_so_ids = user.schemes.each.map(&:scheme_operator_ids).flatten
    company_operator_associated_ids = []
    user.schemes.each do |scheme|
      scheme.businesses.each do |business|
        company_operator_associated_ids << business.company_operator_ids
      end
    end
    company_operator_associated_ids = company_operator_associated_ids.flatten
    company_operator_associated_ids = [1] if company_operator_associated_ids.empty?

    if user.sc_director?
      configure_sc_director(user, scheme_associated_so_ids, company_operator_associated_ids)
    elsif user.sc_super_user?
      configure_sc_super_user(user, scheme_associated_so_ids, company_operator_associated_ids)
    elsif user.sc_user_r?
      can :read, Scheme, id:  user.schemes.map(&:id)
      can :read, SchemeOperator
    elsif user.sc_user_rw?
      can :read, Scheme, id:  user.schemes.map(&:id)
      can :read, SchemeOperator
      can %i(new create), SchemeOperator
    elsif user.sc_user_rwe?
      can :read, Scheme, id:  user.schemes.map(&:id)
      can :read, SchemeOperator
      can %i(new create update edit), SchemeOperator
    end
  end

  def configure_sc_super_user(user, scheme_associated_so_ids, company_operator_associated_ids)
    can :manage, SchemeOperator, id: scheme_associated_so_ids
    can %i(new create), SchemeOperator
    cannot :destroy, SchemeOperator
    can :manage, Scheme, id:  user.scheme_ids
    can %i(new create), Scheme
    can :manage, SchemeOperators::InvitationsController
    can :manage, SchemeOperators::RegistrationsController
    can :manage, CompanyOperators::RegistrationsController
    can :manage, CompanyOperator, id: company_operator_associated_ids
    cannot :destroy, CompanyOperator
    can %i(new create), CompanyOperator
  end

  def configure_sc_director(user, scheme_associated_so_ids, company_operator_associated_ids)
    can :manage, SchemeOperator, id: scheme_associated_so_ids
    can %i(new create), SchemeOperator
    can :manage, Scheme, id:  user.scheme_ids
    can %i(new create), Scheme
    can :manage, SchemeOperators::RegistrationsController
    can :manage, CompanyOperators::RegistrationsController
    can :manage, SchemeOperators::InvitationsController
    can :manage, CompanyOperators::InvitationsController
    can :manage, SchemeOperators::InvitationsController
    can :manage, CompanyOperator, id: company_operator_associated_ids
    can %i(new create), CompanyOperator
  end

  def configure_admin(user)
    if user.full_access?
      can :manage, Admin
      can :manage, CompanyOperator
      can :manage, SchemeOperator
      can :manage, Scheme
      can :manage, SchemeOperators::RegistrationsController
      can :manage, CompanyOperators::RegistrationsController
      can :manage, SchemeOperators::InvitationsController
      can :manage, CompanyOperators::InvitationsController
    end
  end

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
end
