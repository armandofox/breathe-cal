class SessionsController < ApplicationController
    # after_filter:database_cleanup

  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    session[:user_id] = @user.id
    redirect_to root_path
  end
  
  def create_dummy
    if Rails.env.test?
      user_hash = {
        provider: 'some_provider', 
        uid: 101,
        name: "test user",
        oauth_token: 'some_token',
        expire_in_days: 10,
        expire_days_ago: 0,
        email: "test@xxxx.com"
      }
      #params hash has string keys. we must convert them to symbol keys
      #https://stackoverflow.com/questions/800122/best-way-to-convert-strings-to-symbols-in-hash
      symparams = params.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      user_hash = user_hash.merge(symparams)
      @user = User.create_test_user(user_hash)
      session[:user_id] = @user.id
    end
    redirect_to root_path
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
  
  def checklogged
    data = {}
    if session[:user_id] != nil
      data["authorized"] = true;
    end      
    render :json => data
  end
  
  def auth_failure
    flash[:auth_failure] = params[:message] || "Failed to Login"
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
    
    
end
