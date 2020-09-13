class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username, unique: true
      t.string :password_digest
      t.integer :rides_count, default: 0
      t.column :user_type, :integer, default: 1
      t.boolean :is_riding, default: false

      t.timestamps
    end
  end
end
