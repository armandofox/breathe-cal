class SessionsController < ApplicationController
    # after_filter:database_cleanup

  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    self.current_user = @user
    session[:uid] = self.current_user.id
    redirect_to root_path
  end

  # def create 
  #   test_check = params[:test_check]
  #   if test_check
  #     client = Client.new()
  #     client.name = params[:name]
  #     client.provider = 'some provider'
  #     client.oauth_token = 'some token'
  #     client.oauth_expires_at = Time.at(Time.new(2017, 10, 30))
  #     client.save!
  #   else
  #     client = Client.from_omniauth(env["omniauth.auth"])
  #   end 
  #   session[:client_id] = client.id
  #   redirect_to root_path
  # end
  
  def destroy
    session[:client_id] = nil
    redirect_to root_path
  end
  
  def checklogged
    data = {}
    if session[:client_id] != nil
      data["authorized"] = true;
    end      
    render :json => data
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
    
    
end
