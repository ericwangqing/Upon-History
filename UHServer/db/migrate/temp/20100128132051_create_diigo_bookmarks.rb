class CreateDiigoBookmarks < ActiveRecord::Migration
  def self.up
    create_table :diigo_bookmarks do |t|
      t.string :title
      t.string :url
      t.string :desc

      t.timestamps
    end
  end

  def self.down
    drop_table :diigo_bookmarks
  end
end
