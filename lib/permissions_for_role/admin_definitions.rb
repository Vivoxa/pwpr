module PermissionsForRole
  class AdminDefinitions
    ROLES = %w(super_admin normal_admin restricted_admin).freeze
    PERMISSIONS = %w(admins_r admins_w admins_e admins_d).freeze + PermissionsForRole::SharedDefinitions::SHARED_PERMISSIONS

    def permissions_for_role(role)
      definitions[role.to_sym]
    end

    private

    def definitions
      {super_admin: super_admin, normal_admin: normal_admin, restricted_admin: restricted_admin}
    end

    def super_admin
      {
        admins_r:     {checked: true, locked: true},
        admins_w:     {checked: true, locked: true},
        admins_e:     {checked: true, locked: true},
        admins_d:     {checked: true, locked: true},

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
        businesses_d: {checked: true, locked: true},
        uploads_r:    {checked: true, locked: true},
        uploads_w:    {checked: true, locked: true}
      }
    end

    def normal_admin
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
        co_users_w:   {checked: true, locked: true},
        co_users_e:   {checked: true, locked: true},
        co_users_d:   {checked: false, locked: false},

        businesses_r: {checked: true, locked: true},
        businesses_e: {checked: true, locked: true},
        businesses_w: {checked: true, locked: true},
        businesses_d: {checked: false, locked: false},
        uploads_r:    {checked: true, locked: true},
        uploads_w:    {checked: false, locked: false}
      }
    end

    def restricted_admin
      {
        schemes_r:    {checked: true, locked: true},
        schemes_w:    {checked: false, locked: true},
        schemes_e:    {checked: false, locked: false},
        schemes_d:    {checked: false, locked: true},

        sc_users_r:   {checked: true, locked: true},
        sc_users_w:   {checked: false, locked: false},
        sc_users_e:   {checked: false, locked: false},
        sc_users_d:   {checked: false, locked: true},

        co_users_r:   {checked: true, locked: true},
        co_users_w:   {checked: false, locked: false},
        co_users_e:   {checked: false, locked: false},
        co_users_d:   {checked: false, locked: false},

        businesses_r: {checked: true, locked: true},
        businesses_e: {checked: false, locked: false},
        businesses_w: {checked: false, locked: true},
        businesses_d: {checked: false, locked: true},
        uploads_r:    {checked: false, locked: false},
        uploads_w:    {checked: false, locked: true}
      }
    end
  end
end
