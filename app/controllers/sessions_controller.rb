class SessionsController < ApplicationController

  # Creates a user from an auth_hash stored by omniauth gem during login
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    session[:user_id] = @user.id
    redirect_to root_path
  end
  
  # Logs out user by setting session[:user_id] to nil
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
  
  # Triggers when authentication fails. Sets failure message
  def auth_failure
    flash[:auth_failure] = params[:message] || "Failed to Login"
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
    
    
end
