class DiigoComment < ActiveRecord::Base
  extend UhEntry
  ENTITY_OPTION = {:ref_id_name => "diigo_bookmark_id", :include => "diigo_bookmark", :date_in_number => false, :date_field_str => "diigo_created_at"}
  
  belongs_to :diigo_bookmark
  
 
  def self.paginate_comments_within_interval(opts={})
    self.paginate_entries_within_interval(ENTITY_OPTION, opts)
  end
    
  # get comments made today
  def self.paginate_comments_today(opts={})
    self.paginate_entries_today(ENTITY_OPTION, opts)
  end

end
