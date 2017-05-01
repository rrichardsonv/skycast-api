class TestSeeder
  attr_reader :key, :token, :search_id,
              :user_id
  def run_all
    users
    searches
    apikey
  end

  private

  def users
    user_info = {
      email: "test@test.com",
      password:"test"
    }
    user = User.new(user_info)
    if user.save
      @user_id = user.id
      @token = user.auth_token
    else
      raise "Something wrong in seeding users"
    end
  end

  def searches
    search_info = {
      lat: '41.9711068',
      long: '-87.70248169',
      zipcode: '60625',
      user_id: @user_id
    }
    search = Search.new(search_info)
    if search.save
      @search_id = search.id
    else
      raise "something wrong in errand seeding"
    end
  end

  def apikey
    apikey = Apikey.new(domain: "test.com")
    if apikey.save
      @key = apikey.access_key
    else
      raise "something very wrong in apikey seeding"
    end
  end
end