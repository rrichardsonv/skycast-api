require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:test_env){TestSeeder.new}
  describe "Post #create aka create new user" do
    before(:each){test_env.run_all}
    let(:user_params){{user: {email: 'bana@na.com', password: 'password'}}}
    it "returns http created" do
      test_params = user_params.clone
      test_params[:key] = test_env.key 
      post :create, params: test_params

      expect(response).to have_http_status(:created)
    end

    it "returns http unauth without key" do
      post :create, params: user_params
      
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http bad request on no save" do
      # TODO: Throws on no user params rather than bad_request
      post :create, params: {user: {email: 'a'}, key: test_env.key}
      
      expect(response).to have_http_status(:bad_request)
    end

    it "creates a user" do
      test_params = user_params.clone
      test_params[:key] = test_env.key 
      post :create, params: test_params
      user = User.find_by(email: user_params[:user][:email])

      expect(user).not_to be_nil
    end

    it "returns the user's token" do
      test_params = user_params.clone
      test_params[:key] = test_env.key 
      post :create, params: test_params
      user = User.find_by(email: user_params[:user][:email])
      token = user.auth_token
      responseToken = JSON.parse(response.body).fetch("data").fetch("token")

      expect(token).to eq(responseToken)
    end
  end

end
