require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "Post #create aka create new user" do
    let(:user_params){{user: {email: 'bana@na.com', password: 'password'}}}
    it "returns http created" do
      post :create, params: user_params

      expect(response).to have_http_status(:created)
    end

    it "returns http bad request on no save" do
      # TODO: Throws on no user params rather than bad_request
      post :create, params: {user: {email: 'a'}}
      
      expect(response).to have_http_status(:bad_request)
    end

    it "creates a user" do
      post :create, params: user_params
      user = User.find_by(email: user_params[:user][:email])

      expect(user).not_to be_nil
    end

    it "returns the user's token" do
      post :create, params: user_params
      user = User.find_by(email: user_params[:user][:email])
      token = user.auth_token
      responseToken = JSON.parse(response.body).fetch("data").fetch("token")

      expect(token).to eq(responseToken)
    end
  end

end
