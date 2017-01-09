module PermissionsForRole
  class CompanyOperatorDefinitions < BaseDefinitions
    ROLES = %w(co_director co_super_user co_user).freeze
    PERMISSIONS = %w(co_users_r co_users_w co_users_d co_users_e
                     businesses_r businesses_e).freeze

    def permissions_for_role(role)
      logger.tagged('CompanyOperatorDefinitions') do
        logger.info "permissions_for_role() Fetching permissions for role: #{role}"
      end
      definitions[role.to_sym]
    end

    private

    def definitions
      {co_director: co_director, co_super_user: co_super_user, co_user: co_user}
    end

    def co_director
      {
        # co_users_r:   {checked: true, locked: true}
        # co_users_w:   {checked: true, locked: true},
        # co_users_e:   {checked: true, locked: true},
        # co_users_d:   {checked: true, locked: true},
        #
        # businesses_r: {checked: true, locked: true},
        # businesses_e: {checked: true, locked: true}
      }
    end

    def co_super_user
      {
        # co_users_r:   {checked: true, locked: true}
        # co_users_w:   {checked: true, locked: true},
        # co_users_e:   {checked: true, locked: true},
        # co_users_d:   {checked: false, locked: false},
        #
        # businesses_r: {checked: false, locked: false},
        # businesses_e: {checked: false, locked: false}
      }
    end

    def co_user
      {
        # co_users_r:   {checked: true, locked: true}
        # co_users_w:   {checked: false, locked: false},
        # co_users_e:   {checked: false, locked: false},
        # co_users_d:   {checked: false, locked: false},
        #
        # businesses_r: {checked: false, locked: false},
        # businesses_e: {checked: false, locked: true}
      }
    end
  end
end
