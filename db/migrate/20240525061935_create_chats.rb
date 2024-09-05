class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.text :body
      t.integer :relationship_id
      t.timestamps
    end
  end
end
