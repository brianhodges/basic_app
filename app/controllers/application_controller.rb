class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception  
  before_filter :set_timezone
  helper_method :admin_user?, :anonymous_user?, :is_user?, :user_role, :current_user

  def set_timezone
    Time.zone = 'EST'
  end

  def has_role?(role)
    return false if anonymous_user?
    u = User.find_by_id(session[:user_id])
    r = Role.find_by_role(role)
    u && r && u.role_id == r.id
  end
  
  def is_user?(u)
    redirect_to home_path, notice: 'Unauthorized Access - Invalid User' if u != session[:user_id] && !admin_user?
  end
  
  #User Role Object for reference
  def user_role
    r = Role.find_by_role(BASICConsts::USER)
    r
  end

  #Role Checks
  def anonymous_user?
    !session[:user_id].present?
  end
  
  def base_user?
    has_role?(BASICConsts::USER)
  end
  
  def admin_user?
    has_role?(BASICConsts::ADMIN)
  end

  #Methods for controller access
  protected

  def check_authentication
    redirect_to home_path, notice: 'Unauthorized Access' if anonymous_user?
  end
  
  def check_admin_authentication
    redirect_to home_path, notice: 'Unauthorized Access' unless admin_user?
  end
end
