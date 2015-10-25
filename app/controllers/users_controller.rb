class UsersController < ApplicationController

  layout :required_layout

  before_action :confirm_logged_in, :except => [:index, :new, :create, :attempt_login, :logout]

  def index
  	@users = User.all
  	if session[:user_id].present?
  		redirect_to(:controller => "notes", :action => "index")
  	else
  		render("index")
  	end
  end

  def show
  	@user = User.find(params[:id])
  	if @user == current_user
      render("show")
     else
     redirect_to(:controller => "notes", :action => "index")
     end
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      UserMailer.signup_confirmation(@user).deliver
  		redirect_to(:controller => "notes", :action => "index")
      flash[:notice] = "Your account was successfully created. Please verify your email."
  	else
  		render("new")
  	end
  end

  def edit

  	@user = User.find(params[:id])
  	 if @user == current_user
      render("edit")
     else
     redirect_to(:controller => "notes", :action => "index")
     end

  end

  def update
  	@user = User.find(params[:id])
    if @user.update_attributes(user_params)
    	redirect_to(:controller => "users", :action => "show", :id => @user.id)
      flash[:notice] = "Your profile was updated successfully."
    else
    	redirect_to(:controller => "users", :action => "edit", :id => @user.id)
    end
  end


  def attempt_login

  	if params[:email].present? && params[:password].present?
  		found_user = User.where(:email => params[:email]).first  
   
	    if found_user
	    	authorized_user = found_user.authenticate(params[:password])
      end

    end
    
    if authorized_user
    	session[:username] = authorized_user.username
    	session[:user_id] = authorized_user.id
    	session[:email] = authorized_user.email    	
    	session[:first_name] = authorized_user.first_name
    	session[:last_name] = authorized_user.last_name
      session[:profile_picture] = authorized_user.profile_picture
    	
    	redirect_to(:controller => "notes", :action => "index")
    else
    	render("index")      
    end

  end
   def logout
   	   session[:user_id] = nil
       session[:email] = nil
       redirect_to(:controller => "users", :action => "index")
   end




  private

  def user_params
  	params.require(:user).permit(:first_name, :last_name, :username,
  	                             :email, :password, :password_confirmation, :profile_picture)
  end

  def confirm_logged_in
  	unless session[:user_id]
  		redirect_to(:controller => "users", :action => "index")
  		return false
  	else
  		return true
  	end
  end

  def required_layout
  	case action_name

  	when "index","new"
  		"users"
  	when "edit", "show"
  		"notes"
  	end
  end

  def current_user
    current_user = User.find(session[:user_id])
  end

end
