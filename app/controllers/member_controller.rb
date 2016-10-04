# frozen_string_literal: true
class MemberController < ApplicationController
  # before_action :authenticate_member!

  def index
    # @member = Member.all if current_member.admin?
  end

  def show
    # @member = Member.find(params[:id])

    # redirect_to :back, :alert => "Access denied." unless current_member.admin? && @member == current_member
  end

  def update
    # @member = Member.find(params[:id])
    # if @member.update_attributes(secure_params)
      redirect_to member_path, :notice => "User updated."
    # else
    #   redirect_to member_path, :alert => "Unable to update user."
    # end
  end

  def destroy
    # member = Member.find(params[:id])

    # redirect_to :back, :alert => "Action denied." and return unless current_member.admin? && @member == current_member

    # member.destroy
    redirect_to member_path, :notice => "User deleted."
  end

  private

  def secure_params
    # We need to pull the params and handle member as well maybe?

    params.require(:member).permit(:role)
  end
end
