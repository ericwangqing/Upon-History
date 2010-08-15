class CreateDiigoAnnotations < ActiveRecord::Migration
  def self.up
    create_table :diigo_annotations do |t|
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :diigo_annotations
  end
end
