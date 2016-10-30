module CommonHelpers
  module PermissionsHelper
    protected

    def modify_roles_and_permissions(resource_path)
      current = @user.role_list
      begin
        remove_unselected_permissions!

        @user.add_role selected_role.first if selected_role.first

        add_permissions!
      rescue
        roll_back_roles!(current)

        redirect_to resource_path, flash: { error: "An error occured! User #{@user.email}'s permissions were not updated." }
        return
      end

      redirect_to resource_path, flash: { notice: 'Permissions updated successfully!' }
    end

    private

    def selected_permissions
      permissions = params[:permissions] ? params[:permissions] : []
      invalid_permissions = []
      return [] if permissions.empty?

      permissions.each do |p|
        invalid_permissions << p unless allowed_permission?(p)
      end

      permissions - invalid_permissions
    end

    def selected_role
      role = []
      role << params[:role] if params[:role] && @available_roles.include?(params[:role])
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

    def allowed_permission?(permission)
      available_permissions.include?(permission) &&
      (!available_permissions[permission.to_sym][:locked] ||
        available_permissions[permission.to_sym][:checked])
    end

    def available_permissions
      PermissionsForRole::SchemeOperator::permissions_for_role(selected_role)
    end
  end
end
