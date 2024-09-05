class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :content
      t.integer :group_id
      t.timestamps
    end
  end
end
