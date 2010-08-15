class AddDiigoCreatedUpdatedFieldsToModel < ActiveRecord::Migration
  def self.up
    add_column :diigo_bookmarks, :diigo_created_at, :datetime
    add_column :diigo_bookmarks, :diigo_updated_at, :datetime
    
    add_column :diigo_annotations, :diigo_created_at, :datetime
    
    add_column :diigo_comments, :diigo_created_at, :datetime
  end

  def self.down
    remove_column :diigo_bookmarks, :diigo_created_at
    remove_column :diigo_bookmarks, :diigo_updated_at
    remove_column :diigo_annotations, :diigo_created_at
    remove_column :diigo_comments, :diigo_created_at
  end
end
