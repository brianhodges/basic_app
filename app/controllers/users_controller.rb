class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == BASICConsts::JSON }

  #POST /my_info
  def my_info
    user_id = params[:user_id]
    @user = User.find_by_id(user_id)
    @img_updated = 0
    if params[:profile_image_id].present?
      i = UserImage.find_by_id(params[:profile_image_id])
      if i
        @user.profile_image_id = i.id
        @user.api_post_unrestricted = true
        @user.save!
        @img_updated = 1
      end
    else
      if @user.profile_image_id
        i = UserImage.find_by_id(@user.profile_image_id)
        @image = Base64.encode64(i.data) unless !i
      end
    end
    @status = ((params[:profile_image_id].present? && i) || @user) ? 1 : 0
  end
  
  #POST /create_user
  def create_user
    p = params[:p] unless !params[:p].present?
    if p
      u = User.new
      u.email = params[:email]
      u.first_name = params[:fname]
      u.last_name = params[:lname]
      u.password_salt = SCrypt::Engine.generate_salt
      u.password_hash = SCrypt::Engine.hash_secret(p, u.password_salt)
      u.role_id = user_role.id
      u.api_post_unrestricted = true
      if u.save
        status = 1
      else
        x = 0
        status = ""
        u.errors.each do |attribute, message|
          status = (x == 0) ? "#{attribute.to_s.humanize} #{message}" : status + ", #{attribute.to_s.humanize} #{message}" 
          x += 1
        end
      end
    else
      status = "Password can't be blank."
    end
    render :json => status
  end
  
  #POST /update_user
  def update_user
    user_id = params[:user_id]
    if user_id
      p = params[:p] unless !params[:p].present?
      if p
        u = User.find_by_id(user_id)
        u.email = params[:email]
        u.first_name = params[:fname]
        u.last_name = params[:lname]
        u.password_salt = SCrypt::Engine.generate_salt
        u.password_hash = SCrypt::Engine.hash_secret(p, u.password_salt)
        u.api_post_unrestricted = true
        if u.save
          status = 1
        else
          x = 0
          status = ""
          u.errors.each do |attribute, message|
            status = (x == 0) ? "#{attribute.to_s.humanize} #{message}" : status + ", #{attribute.to_s.humanize} #{message}"
            x += 1
          end
        end
      else
        status = "Password can't be blank."
      end
    else
      status = 0 
    end
    render :json => status
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.order(:id)
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
    check_authentication
    is_user?(@user.id) unless anonymous_user?
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    check_authentication
    is_user?(@user.id) unless anonymous_user?
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.save ? (redirect_to login_url, :notice => "Signed up! Please log in.") : (render "new")
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password_hash, :password_salt, :role_id, :password, :password_confirmation)
    end
end
