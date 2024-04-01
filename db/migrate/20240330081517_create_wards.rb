class CreateWards < ActiveRecord::Migration[7.0]
  def change
    create_table :wards do |t|
      t.string :name, null: false, default: ""
      t.string :summary, null: false, default: ""
      t.integer :one_ldk_avg_rent
      t.integer :two_ldk_avg_rent
      t.integer :three_ldk_avg_rent
      t.integer :safety
      t.integer :population
      t.float :pet_percentage

      t.timestamps
    end
    add_index :wards, :name, unique: true
  end
end
