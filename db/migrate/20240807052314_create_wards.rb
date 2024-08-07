class CreateWards < ActiveRecord::Migration[7.0]
  def change
    create_table :wards do |t|
      t.string :name, index: true
      t.integer :one_ldk_avg_rent
      t.integer :two_ldk_avg_rent
      t.integer :three_ldk_avg_rent
      t.float :safety_rating
      t.float :pet_percentage
      t.integer :international_schools

      t.timestamps
    end
  end
end
