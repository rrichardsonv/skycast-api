class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token
  after_validation :date_that_token

  has_many :searches

  def queries
    self.searches.select(:zipcode, :id).distinct.collect do |search|
      {
        id: search.id,
        zipcode: search.zipcode
      }
    end
  end

  def date_that_token
    self.token_created_at = Time.now
  end

  def invalidate_token
    self.update_columns(auth_token: nil)
  end
  def regenerate_token
    self.auth_token = User.generate_unique_secure_token
    self.save
  end

  def self.with_unexpired_token(token, period)
    User.where(auth_token: token).where('token_created_at >= ?', period).first
  end

  def logout
    invalidate_token
  end
end
