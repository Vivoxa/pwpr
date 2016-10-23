module CommonHelpers
  module PermissionsHelper
    SHARED_SO_ADMIN_PERMISSIONS = %w(sc_users_r sc_users_w sc_users_e sc_users_d
                                     co_users_r co_users_w co_users_d co_users_e
                                     businesses_r businesses_w businesses_d businesses_e
                                     schemes_r schemes_w schemes_d schemes_e).freeze

    protected

    def modify_roles_and_permissions(resource_path)
      current = @user.role_list
      begin
        remove_unselected_permissions!

        @user.add_role selected_role.first

        add_permissions!
      rescue
        roll_back_roles!(current)

        redirect_to resource_path, error: "An error occured! User #{@user.email}'s permissions were not updated."
        return
      end

      redirect_to resource_path, notice: 'Permissions updated succesfully!'
    end

    private

    def selected_permissions
      params[:permissions] ? params[:permissions] : []
    end

    def selected_role
      role = []
      role << params[:role] if params[:role]
      role
    end

    def removed_roles_and_permissions
      @user.role_list - selected_role - selected_permissions
    end

    def roll_back_roles!(current)
      current.each do |r|
        @user.add_role r
      end
    end

    def add_permissions!
      selected_permissions.each do |p|
        @user.add_role p if p
      end
    end

    def remove_unselected_permissions!
      removed_roles_and_permissions.each do |r|
        @user.remove_role r if r
      end
    end
  end
end
