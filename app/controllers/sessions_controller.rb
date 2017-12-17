class SessionsController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == BASICConsts::JSON }

  def home
  end
  
  def new
    redirect_to user_path(session[:user_id]), :notice => 'Already Logged in!' unless anonymous_user?
  end

  #POST /auth
  def auth
    email = params[:email]
    p = params[:p]
    status = 0
    if email.present? && p.present?
      user = User.find_by_email(email.downcase)
      status = (user && user.password_hash == SCrypt::Engine.hash_secret(p, user.password_salt)) ? user.id : status
    end
    render json: status
  end
  
  def create    
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to user_path(session[:user_id])
    else
      redirect_to login_path, notice: 'Invalid email or password'
    end
  end
  
  def destroy
    @user = nil
    session[:user_id] = nil
    redirect_to home_path, notice: 'Logout successful'
  end
end
