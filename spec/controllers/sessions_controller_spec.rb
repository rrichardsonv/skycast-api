require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:test_env){TestSeeder.new}
  let(:user_data){{
    email: "imanemail@mail.com",
    password: "password"
  }}

  describe "Sessions#create" do
    before(:each){test_env.run_all}
    before(:each){User.create!(user_data)}

    it "returns http success when accompanied with apikey" do
      keyed_user_data = user_data.clone
      keyed_user_data[:key] = test_env.key
      post :create, params: keyed_user_data
      expect(response).to have_http_status(:success)
    end

    it "returns unauth without key" do
      unkeyed_user_data = user_data.clone
      post :create, params: unkeyed_user_data
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns a token on successful login" do
      keyed_user_data = user_data.clone
      keyed_user_data[:key] = test_env.key
      post :create, params: keyed_user_data
      expect(response.content_type).to eq("application/json")
      expect(JSON.parse(response.body).fetch('data').fetch("token")).to match(/[[[:alpha:]][[:digit:]]]{24}/)
    end

    it "return bad request when no password match is found" do
      keyed_user_data = {password: "123123413472354234134724512351346", email: user_data[:email]}
      keyed_user_data[:key] = test_env.key
      post :create, params: keyed_user_data
      expect(response).to have_http_status(:bad_request)
    end

    it "return bad request when no email match is found" do
      keyed_user_data = {password: "password", email: "12365124361234762354723458354683456834568"}
      keyed_user_data[:key] = test_env.key
      post :create, params: keyed_user_data
      expect(response).to have_http_status(:bad_request)
    end

    it "generates a new unique token on login" do
      keyed_user_data = user_data.clone
      keyed_user_data[:key] = test_env.key

      post :create, params: keyed_user_data
      first_token = JSON.parse(response.body).fetch('data').fetch('token')

      post :create, params: keyed_user_data
      second_token = JSON.parse(response.body).fetch('data').fetch('token')


      expect(first_token).not_to eq(second_token)
    end
  end

  describe "Sessions#destroy" do
    before(:each){test_env.run_all}

    it "returns http success when accompanied with apikey and token" do
      user = User.find(test_env.user_id)
      keyed_and_tokened_data = {token: user.auth_token, key: test_env.key}
      delete :destroy, params: keyed_and_tokened_data
      expect(response).to have_http_status(:success)
    end

    it "returns unauth without key" do
      user = User.find(test_env.user_id)
      unkeyed_data = {token: user.auth_token}
      delete :destroy, params: unkeyed_data
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns unauth without token" do
      untokened_user_data = {key: test_env.key}
      delete :destroy, {params: untokened_user_data}
      expect(response).to have_http_status(:unauthorized)
    end

    it "invalidates the user token on success" do
      user = User.find(test_env.user_id)
      before_token = user.auth_token
      keyed_and_tokened_data = {token: before_token, key: test_env.key}
      delete :destroy, params: keyed_and_tokened_data
      after_token = User.find(test_env.user_id).auth_token
      expect(after_token).not_to eq(before_token)
    end
  end
end
