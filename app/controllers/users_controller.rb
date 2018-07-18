class UsersController < ApplicationController
    # Currently user controller actions can only be accessed by logged in users
    before_filter :require_real_login
    
    def index
    end
    
    def create
    end
    
    def new
    end
    
    def edit
    end
    
    def show
        id = params[:id].to_i # retrieve user ID from URI route
        # Checks to see if user_id matches with the id passed in by URI
        if session[:user_id] != id
            flash[:profile] = "Cannot View Profile: Invalid UID"
            redirect_to root_path
        else
            @user = User.find(id)
        end
    end
    
    def update
    end
    
    def destroy
    end
    
    private
    
    # Checks to see if a user (not a guest) is logged in with id = session[:user_id]
    # Name chosen so as not to conflict with require_login for application_controller
    def require_real_login
        if !session[:user_id]
            flash[:profile] = "Cannot View Profile: Not Signed In"
            redirect_to root_path
        end
    end
end