class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches do |t|
      t.integer :user_id
      t.string :zipcode
      t.string :lat
      t.string :long

      t.timestamps
    end
  end
end
