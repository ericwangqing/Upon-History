class CreateDiigoComments < ActiveRecord::Migration
  def self.up
    create_table :diigo_comments do |t|
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :diigo_comments
  end
end
