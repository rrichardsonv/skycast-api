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
      keyed_user_data = {password: user_data[:password], email: user_data[:email]}
      keyed_user_data[:key] = test_env.key
      post :create, keyed_user_data
      expect(response).to have_http_status(:success)
    end

    it "returns unauth without key" do
      unkeyed_user_data = {password: user_data[:password], email: user_data[:email]}
      post :create, unkeyed_user_data
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns a token on successful login" do
      keyed_user_data = {password: user_data[:password], email: user_data[:email]}
      keyed_user_data[:key] = test_env.key
      post :create, keyed_user_data
      expect(response.content_type).to eq("application/json")
      expect(JSON.parse(response.body).fetch("token")).to match(/[[[:alpha:]][[:digit:]]]{24}/)
    end

    it "return bad request when no password match is found" do
      keyed_user_data = {password: "123123413472354234134724512351346", email: user_data[:email]}
      keyed_user_data[:key] = test_env.key
      post :create, keyed_user_data
      expect(response).to have_http_status(:bad_request)
    end

    it "return bad request when no email match is found" do
      keyed_user_data = {password: "password", email: "12365124361234762354723458354683456834568"}
      keyed_user_data[:key] = test_env.key
      post :create, keyed_user_data
      expect(response).to have_http_status(:bad_request)
    end

    it "generates a new unique token on login" do
      keyed_user_data = {password: user_data[:password], email: user_data[:email]}
      keyed_user_data[:key] = test_env.key

      post :create, keyed_user_data
      first_token = JSON.parse(response.body).fetch('token')

      post :create, keyed_user_data
      second_token = JSON.parse(response.body).fetch('token')


      expect(first_token).not_to eq(second_token)
    end
  end
end
