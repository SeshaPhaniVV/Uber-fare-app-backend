class CreateRides < ActiveRecord::Migration[6.0]
  def change
    create_table :rides do |t|
      t.integer :user_id
      t.integer :driver_id
      t.datetime :ride_book_time
      t.datetime :ride_start_time
      t.datetime :ride_end_time
      t.integer :rating, default: -1
      t.float :fare, default: -1

      t.timestamps
    end
  end
end
