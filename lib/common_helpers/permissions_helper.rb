module CommonHelpers
  module PermissionsHelper
    protected

    def modify_roles_and_permissions
      current = @user.role_list
      begin
        remove_unselected_permissions!

        @user.add_role selected_role.first

        add_permissions!
      rescue
        roll_back_roles!(current)

        redirect_to scheme_operator_path @user.id, error: "An error occured! User #{@user.email}'s permissions were not updated.", status: :unprocessable_entity # 422
        return
      end

      redirect_to scheme_operator_path @user.id, notice: 'Permissions updated succesfully!', status: :ok # 302
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

    def add_permissions!(selected_permissions)
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
