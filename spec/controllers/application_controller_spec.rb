require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render :nothing => true
    end
  end

  describe "handling AccessDenied exceptions" do
    it "redirects to the /401.html page" do
      get :index
      expect(response).to redirect_to("/401.html")
    end
  end
end