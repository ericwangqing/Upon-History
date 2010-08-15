class DiigoAnnotation < ActiveRecord::Base
  extend UhEntry
  ENTITY_OPTION = {:ref_id_name => "diigo_bookmark_id", :include => "diigo_bookmark", :date_in_number => false, :date_field_str => "diigo_created_at"}
  
  belongs_to :diigo_bookmark
  
  define_index do
    indexes content
    indexes diigo_bookmark.title :as => :title
    indexes diigo_bookmark.diigo_tags.name :as => :tag
    indexes diigo_bookmark.desc :as => :desc
    
    has diigo_created_at
  end
  
  def self.paginate_annotations_within_interval(opts={})
    self.paginate_entries_within_interval(ENTITY_OPTION, opts)
  end
    
  # get annotations made today
  def self.paginate_annotations_today(opts={})
    self.paginate_entries_today(ENTITY_OPTION, opts)
  end

end
