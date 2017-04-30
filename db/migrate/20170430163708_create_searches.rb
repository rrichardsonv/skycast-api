class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches do |t|
      t.integer :user_id
      t.string :query

      t.timestamps
    end
  end
end
