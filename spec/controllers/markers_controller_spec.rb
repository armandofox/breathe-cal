require 'rails_helper'
RSpec.describe MarkersController, type: :controller do

  describe "POST #create" do
    it "renders marker object as json" do
      post :create, {marker: {cat: true, lat: 10, lng: 10}}
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    it "renders marker objects as json" do
      get :show, {bounds: {uplat: 20, downlat: 10, rightlong: 20, leftlong: 10}}
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE #destroy" do
    it "deletes the marker" do
      @fake_marker = FactoryGirl.create(:marker)
      expect{@fake_marker.destroy}.to change{ Marker.count }.by(-1)
      expect(response).to have_http_status(200)
    end
  end
end
