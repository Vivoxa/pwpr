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

        redirect_to resource_path, flash: {error: "An error occured! User #{@user.email}'s permissions were not updated."}
        return
      end

      redirect_to resource_path, flash: {notice: 'Permissions updated successfully!'}
    end

    private

    def selected_permissions
      permissions = params[:permissions] ? params[:permissions] : []

      # Server side validation
      definitions = @definitions.permissions_for_role(selected_role.first)
      permissions -= invalid_permissions(definitions, permissions)
      permissions += mandatory_permissions(definitions, permissions)

      permissions
    end

    # Remove invalid permissions
    def invalid_permissions(definitions, permissions)
      invalid_permissions = []

      definitions.keys.each do |p|
        invalid_permissions << p.to_s unless allowed?(definitions, p.to_s)
      end

      invalid_permissions
    end

    # Ensure mandatory permissions for role are included
    def mandatory_permissions(definitions, permissions)
      mandatory = []

      definitions.keys.each do |p|
        mandatory << p.to_s if !permissions.include?(p.to_s) && mandatory?(definitions, p.to_s)
      end

      mandatory
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

    def allowed?(definitions, permission)
      definitions.keys.include?(permission.to_sym) &&
      !definitions[permission.to_sym][:locked]
    end

    def mandatory?(definitions, permission)
      definitions.keys.include?(permission.to_sym) &&
      definitions[permission.to_sym][:checked] &&
      definitions[permission.to_sym][:locked]
    end
  end
end
