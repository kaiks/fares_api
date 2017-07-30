class CreateFares < ActiveRecord::Migration[5.1]
  def change
    create_table :fares do |t|
      t.decimal :price, null: false, precision: 8, scale: 2
      t.string :currency, length: 3, null: false
      t.integer :container_type, null: false
      t.string :source, null: false
      t.string :destination, null: false
      t.date :valid_from, null: false
      t.date :valid_to

      t.timestamps
    end
  end
end
