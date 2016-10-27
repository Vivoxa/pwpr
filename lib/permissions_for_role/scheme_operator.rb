module PermissionsForRole
  class SchemeOperator
    # include PermissionsForRole::SharedPermissions::SHARED_PERMISSIONS
    ROLES = %w(sc_director sc_super_user sc_user).freeze
    PERMISSIONS = PermissionsForRole::SharedPermissions::SHARED_PERMISSIONS

    def permissions_for_role(role)
      definitions[role.to_sym]
    end

    private

    def definitions
      {sc_director: sc_director, sc_super_user: sc_super_user, sc_user: sc_user}
    end

    def sc_director
      {
        schemes_r:    {checked: true, locked: true},
        schemes_w:    {checked: true, locked: true},
        schemes_e:    {checked: true, locked: true},
        schemes_d:    {checked: true, locked: true},

        sc_users_r:   {checked: true, locked: true},
        sc_users_w:   {checked: true, locked: true},
        sc_users_e:   {checked: true, locked: true},
        sc_users_d:   {checked: true, locked: true},

        co_users_r:   {checked: true, locked: true},
        co_users_w:   {checked: true, locked: true},
        co_users_e:   {checked: true, locked: true},
        co_users_d:   {checked: true, locked: true},

        businesses_r: {checked: true, locked: true},
        businesses_e: {checked: true, locked: true},
        businesses_w: {checked: true, locked: true},
        businesses_d: {checked: true, locked: true}
      }
    end

    def sc_super_user
      {
        schemes_r:    {checked: true, locked: true},
        schemes_w:    {checked: false, locked: false},
        schemes_e:    {checked: true, locked: true},
        schemes_d:    {checked: false, locked: false},

        sc_users_r:   {checked: true, locked: true},
        sc_users_w:   {checked: true, locked: true},
        sc_users_e:   {checked: true, locked: true},
        sc_users_d:   {checked: false, locked: false},

        co_users_r:   {checked: true, locked: true},
        co_users_w:   {checked: false, locked: false},
        co_users_e:   {checked: false, locked: false},
        co_users_d:   {checked: false, locked: false},

        businesses_r: {checked: true, locked: true},
        businesses_e: {checked: true, locked: true},
        businesses_w: {checked: true, locked: true},
        businesses_d: {checked: false, locked: false}
      }
    end

    def sc_user
      {
        schemes_r:    {checked: false, locked: true},
        schemes_w:    {checked: false, locked: true},
        schemes_e:    {checked: false, locked: true},
        schemes_d:    {checked: false, locked: true},

        sc_users_r:   {checked: false, locked: true},
        sc_users_w:   {checked: false, locked: true},
        sc_users_e:   {checked: false, locked: true},
        sc_users_d:   {checked: false, locked: true},

        co_users_r:   {checked: true, locked: true},
        co_users_w:   {checked: false, locked: false},
        co_users_e:   {checked: false, locked: false},
        co_users_d:   {checked: false, locked: false},

        businesses_r: {checked: true, locked: true},
        businesses_e: {checked: false, locked: false},
        businesses_w: {checked: false, locked: true},
        businesses_d: {checked: false, locked: true}
      }
    end
  end
end
