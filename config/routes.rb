Rails.application.routes.draw do
  
  #Images
  get '/user_images/display_image/:id' => 'user_images#display_image', :as => :display_image
  get '/user_images/download_image/:id' => 'user_images#download_image', :as => :download_image
  get 'update_profile_pic' => 'user_images#update_profile_pic', :as => :update_profile_image
  get '/save_profile_image_id' => 'user_images#save_profile_image_id'
  
  #Scaffolds
  resources :users
  resources :roles
  resources :sessions, :only => [:create]
  with_options(except: [:edit, :update, :index]) do |opt|
    opt.resources :user_images
  end
  
  #Needed for Login/Authentication
  get 'register' => 'users#new', :as => 'register'
  get 'login' => 'sessions#new', :as => 'login'
  get 'logout' => 'sessions#destroy', :as => 'logout'
  
  #Mobile APIs
  post '/auth' => 'sessions#auth'
  post '/create_user' => 'users#create_user'
  post '/update_user' => 'users#update_user'
  post '/create_user_image/:user_id' => 'user_images#create_user_image'
  post '/my_info' => 'users#my_info'
  post '/my_photos' => 'user_images#my_photos'
  post '/my_photo' => 'user_images#my_photo'
  
  root :to => 'sessions#home', :as => :home
end
