class DropBookTags < ActiveRecord::Migration[6.0]
  def change
    drop_table :book_tags, if_exists: true
  end
end
