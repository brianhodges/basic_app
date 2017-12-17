class UserImagesController < ApplicationController
  before_action :set_user_image, only: [:show, :display_image, :download_image, :destroy]
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == BASICConsts::JSON }
  
  #POST /my_photos
  def my_photos
    user_id = params[:user_id] unless !params[:user_id].present?
    @images = UserImage.where(user_id: user_id)
    @status = (@images && !@images.empty?) ? 1 : 0
  end
  
  #POST /my_photo
  def my_photo
    image_id = params[:image_id] unless !params[:image_id].present?
    @image = UserImage.find_by_id(image_id)
    @status = (params[:delete] == '1' || @image) ? 1 : 0
    if @image && params[:delete] == '1'
      user = User.find_by_id(@image.user_id)
      if user.profile_image_id == @image.id
        user.profile_image_id = nil
        user.api_post_unrestricted = true
        user.save!
      end
      @image.destroy!
      @image = 1
    end
  end
  
  #POST /create_user_image
  def create_user_image
    user_id = params[:user_id] unless !params[:user_id].present?
    u = User.find_by_id(user_id)
    status = 0
    if u
      i = UserImage.new
      i.data = request.body.read
      i.content_type = "image/jpeg"
      i.filename = "#{SecureRandom.hex}.jpg"
      i.user_id = u.id
      if i.save!
        status = 1
      end
    end
    render :json => status
  end
  
  def show
    check_authentication
    @user = User.find_by_id(@user_image.user_id)
    is_user?(@user.id) unless anonymous_user?
  end
  
  def update_profile_pic
    check_authentication
    @user = User.find_by_id(session[:user_id])
  end
  
  def save_profile_image_id
    u = User.find_by_id(session[:user_id])
    if u && params[:image]
      i = UserImage.find_by_id(params[:image])
      if i
        u.profile_image_id = i.id
        u.api_post_unrestricted = true
        u.save!
      end
      redirect_to u
    else
      redirect_to :home, notice: 'Something went wrong.'
    end
  end
  
  def display_image
    check_authentication
    if !anonymous_user?
      is_user?(@user_image.user_id)
      send_data @user_image.data, :type => @user_image.content_type, :disposition => 'inline'
    end
  end
  
  def download_image
    check_authentication
    if !anonymous_user?
      is_user?(@user_image.user_id)
      send_data @user_image.data, :type => @user_image.content_type, :filename => @user_image.filename
    end
  end
  
  def new
    check_authentication
    @user = (params[:id] && admin_user?) ? User.find_by_id(params[:id]) : User.find_by_id(session[:user_id])
    @user_image = UserImage.new
  end

  def create
    begin
      @user_image = UserImage.new
      @user_image.uploaded_file = params[:user_image]
      @user_image.user_id = params[:user_image][:user_id]
  
      if @user_image.save
        flash[:notice] = "Image added!"
        redirect_to user_path(id: @user_image.user_id)
      else
        flash[:error] = "There was an error."
        render :action => "new"
      end
    rescue
      redirect_to new_user_image_path, notice: 'You must select an image first'
    end
  end
  
  def destroy
    u = User.find_by_id(@user_image.user_id)
    if u.profile_image_id == @user_image.id
      u.profile_image_id = nil
      u.api_post_unrestricted = true
      u.save!
    end
    @user_image.destroy
    respond_to do |format|
      format.html { redirect_to user_path(u.id), notice: 'User Image was successfully deleted.' }
      format.json { head :no_content }
    end
  end
  
  private
  
    def set_user_image
      @user_image = UserImage.find(params[:id])
    end
    
    def user_image_params
      params.require(:user_image).permit(:filename, :content_type, :data, :user_id)
    end
end
