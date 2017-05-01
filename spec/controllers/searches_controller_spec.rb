require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let(:test_env){TestSeeder.new}

  # describe 'GET #index aka request user searches' do

  #   it "returns success for get request with a proper key and token" do
  #     test_env.run_all
  #     get :index, params: { 
  #       key: "#{test_env.key}",
  #       token: "#{test_env.token}"
  #     }
  #     expect(response).to have_http_status(:success)
  #   end

  #   it "returns unauthorized for get request without credentials" do
  #     get :index
  #     expect(response).to have_http_status(:unauthorized)
  #   end

  #   it "returns searches for authenticated user" do
  #     test_env.run_all
  #     user = User.find(test_env.user_id)
  #     jsonResponse = { data: user.queries }.to_json

  #     get :index, params: {
  #       key: "#{test_env.key}",
  #       token: "#{test_env.token}"  
  #     }
  #     expect(response.content_type).to eq("application/json")

  #     expect(JSON.parse(response.body).fetch("data")).to eq(JSON.parse(jsonResponse).fetch("data"))
  #   end
  # end

  # describe "Post #create aka store new query" do
  #   # let(:test_env){test_seeder.new}
      
  #   let(:search_data){{
  #     zipcode: '60625',
  #     lat:'41.9711068',
  #     long: '-87.70248169'
  #   }}

  #   it "returns http created with all params" do
  #     test_env.run_all
  #     user = User.last
  #     post :create, params: {
  #       key: "#{test_env.key}",
  #       token: "#{test_env.token}",
  #       :lat=>"#{search_data[:lat]}",
  #       :long => "#{search_data[:long]}",
  #       :zipcode => "#{search_data[:zipcode]}"
  #           }  
  #     expect(response).to have_http_status(:created)
  #   end

  #   it "returns the response in json format" do
  #     test_env.run_all
  #     user = User.last
  #     post :create, params: {
  #       key: "#{test_env.key}",
  #       token: "#{test_env.token}",
  #       :lat=>"#{search_data[:lat]}",
  #       :long => "#{search_data[:long]}",
  #       :zipcode => "#{search_data[:zipcode]}"
  #     }
  #     expect(response.content_type).to eq("application/json")
  #   end

  #   it "also returns the associated search data" do
  #     test_env.run_all
  #     user = User.last
  #     post :create, params: {
  #       key: "#{test_env.key}",
  #       token: "#{test_env.token}",
  #       :lat=>"#{search_data[:lat]}",
  #       :long => "#{search_data[:long]}",
  #       :zipcode => "#{search_data[:zipcode]}"
  #     }
  #     latRe = Regexp.new("^#{search_data[:lat].sub(/\./,'\.')}")
  #     longRe = Regexp.new("^#{search_data[:long].sub(/\./,'\.')}")

  #     responseBody = JSON.parse(response.body).fetch("data")
  #     resp_coords = {lat:'latitude', long:'longitude'}
  #     resp_coords.each do |key,val|
  #       resp_coords[key] = responseBody.fetch(val).to_s
  #     end

  #     expect(resp_coords[:lat]).to match(latRe) 
  #     expect(resp_coords[:long]).to match(longRe)
  #   end

  #   it "returns partial content without a token" do
  #     test_env.run_all
  #     post :create, params: {
  #       key: "#{test_env.key}",
  #       :lat=>"#{search_data[:lat]}",
  #       :long => "#{search_data[:long]}",
  #       :zipcode => "#{search_data[:zipcode]}"
  #     }
  #     expect(response).to have_http_status(:partial_content)
  #   end

  #   it "stores the new search" do
  #     test_env.run_all
  #     user = User.last
  #     post :create, params: {
  #       key: "#{test_env.key}",
  #       token: "#{test_env.token}",
  #       :lat=>"#{search_data[:lat]}",
  #       :long => "#{search_data[:long]}",
  #       :zipcode => "#{search_data[:zipcode]}"
  #     }
  #     search = Search.last

  #     expect(search.lat).to eq(search_data[:lat])
  #     expect(search.long).to eq(search_data[:long])
  #     expect(search.zipcode).to eq(search_data[:zipcode])
  #     expect(search.user_id).to eq(user.id)
  #   end
  # end

end
