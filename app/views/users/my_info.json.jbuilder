if @user
    json.email @user.email
    json.first_name @user.first_name.capitalize unless (@user.first_name.nil? || @user.first_name.blank?)
    json.last_name @user.last_name.capitalize unless (@user.last_name.nil? || @user.last_name.blank?)
    json.profile_image_id @image unless @image.nil?
end
json.status @status
json.profile_pic_updated @img_updated