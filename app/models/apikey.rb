class Apikey < ApplicationRecord
  before_save :generate_access_key

  def generate_access_key
    self.access_key = SecureRandom.hex(6)
  end
end
# 6b0d09684982