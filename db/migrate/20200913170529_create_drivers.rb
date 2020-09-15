class CreateDrivers < ActiveRecord::Migration[6.0]
  def change
    create_table :drivers do |t|
      t.string :drivername, unique: true
      t.float :rating
      t.integer :rides_count, default: 0
      t.integer :ratings_count, default: 0
      t.column :status, :integer, default: 1

      t.timestamps
    end
  end
end
