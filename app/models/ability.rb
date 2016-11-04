class Ability
  include CanCan::Ability

  def initialize(user)
    self.merge Abilities.ability_for(user)
  end
end