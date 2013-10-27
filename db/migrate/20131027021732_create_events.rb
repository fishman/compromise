class CreateEvents < ActiveRecord::Migration
  def change
    create_table(:events) do |t|
      t.string :type
      t.string :description
      t.integer :user_id
      t.timestamp :starts_at
      t.timestamp :ends_at
      t.boolean :processed, :default => true
      
      t.timestamps
    end
    add_index :events, :type
    add_index :events, :user_id
    add_index :events, :starts_at
    add_index :events, :ends_at
    add_index :events, :processed
  end
end
