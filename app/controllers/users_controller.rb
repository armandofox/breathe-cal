class UsersController < ApplicationController
    before_filter :require_real_user
    
    def index
    end
    
    def create
    end
    
    def new
    end
    
    def edit
    end
    
    def show
        @user = User.find(params[:id])
        @name = user.name
        @email = user.email
    end
    
    def update
    end
    
    def destroy
    end
    
    private
    
    def require_real_user
        if !session[:user_id]
            flash[:profile] = "Cannot View Profile: Not Signed In"
            redirect_to root_path
        elsif session[:user_id] != params[:id]
            flash[:profile] = "Cannot View Profile: Invalid UID"
            redirect_to root_path
        end
    end
end