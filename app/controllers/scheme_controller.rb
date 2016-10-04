# frozen_string_literal: true
class SchemeController < ApplicationController
  # before_action :authenticate_scheme!
  # before_action :scheme_and_admin_user_only


  def index
    # Show a categorized list of users based on type (scheme(admins) and member)
  end

  def show
    # We need to figure a scope to search for users dynamically based on the category
    # in order to be able to search for the one clicked on in the right table
    # @user = User.find(params[:id])

    # redirect_to :back, :alert => "Access denied." unless current_scheme || current_admin && @user == current_admin

    # redirect_to member_show_path if @user.is_member?
  end

  def update
    # @scheme = Scheme.find(params[:id])
    # if @scheme.update_attributes(secure_params)
      redirect_to scheme_path, :notice => "User updated."
    # else
    #   redirect_to scheme_path, :alert => "Unable to update user."
    # end
  end

  def destroy
    # scheme = Scheme.find(params[:id])

    # redirect_to :back, :alert => "Action denied." and return unless current_admin && current_scheme.admin? && scheme == current_scheme

    # member.destroy
    redirect_to scheme_path, :notice => "User deleted."
  end

  private

  def scheme_and_admin_user_only
    redirect_to :back, alert: 'Access denied.' unless current_scheme || current_admin
  end

  def secure_params
    # We need to pull the params and handle member as well maybe?

    params.require(:scheme).permit(:role)
  end
end
