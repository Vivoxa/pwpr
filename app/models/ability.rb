class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:

    user ||= Visitor.new

    configure_scheme_operator(user) if user.is_a?(SchemeOperator)

    configure_company_operator(user) if user.is_a?(CompanyOperator)

    configure_admin(user) if user.is_a?(Admin)
  end

  private

  def configure_company_operator(user)
  end

  def configure_scheme_operator(user)
    if user.scheme_owner?
      can :manage, SchemeOperator
      can :manage, Scheme, id:  user.schemes.map(&:id)
    else
      can :read, Scheme, id:  user.schemes.map(&:id)
    end
  end

  def configure_admin(user)
    if user.full_access?
      can :manage, Admin
      can :manage, CompanyOperator
      can :manage, SchemeOperator
      can :manage, Scheme
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
