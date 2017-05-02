class CreateApikeys < ActiveRecord::Migration[5.0]
  def change
    create_table :apikeys do |t|
      t.string :access_key
      t.string :domain

      t.timestamps
    end
  end
end
