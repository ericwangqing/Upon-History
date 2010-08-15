class AddDiigoRelationships < ActiveRecord::Migration
  def self.up
    add_column :diigo_comments, :diigo_bookmark_id, :integer
    add_column :diigo_annotations, :diigo_bookmark_id, :integer
    
    create_table :diigo_bookmarks_diigo_tags do |t|
      t.integer :diigo_bookmark_id
      t.integer :diigo_tag_id
    end
  end

  def self.down
    remove_column :diigo_comments, :diigo_bookmark_id
    remove_column :diigo_annotations, :diigo_bookmark_id
    drop_table :diigo_bookmarks_diigo_tags
  end
end
