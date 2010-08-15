class CreateDiigoTags < ActiveRecord::Migration
  def self.up
    create_table :diigo_tags do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :diigo_tags
  end
end
