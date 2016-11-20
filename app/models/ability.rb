class Ability
  include CanCan::Ability
  include Logging

  def initialize(user)
    logger.tagged('Ability(C)') do
      logger.info "initialize() merging abilities for user: #{user.inspect}"
      self.merge Abilities.ability_for(user)
    end
  end
end