class AddTokenDatingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column(:users, :token_created_at, :datetime)
  end
end
