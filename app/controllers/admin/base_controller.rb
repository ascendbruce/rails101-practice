class Admin::BaseController < ApplicationController
  layout "admin"
  before_filter :authenticate_admin!

  protected

  def authenticate_admin! #TODO: authenticate_admin, admin_required or require_is_admin
    unless current_user && current_user.is_admin?
      redirect_to root_path, :alert => "You are not admin!"
    end
  end
end
