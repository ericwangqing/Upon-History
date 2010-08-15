class UhaAnnotation < ActiveRecord::Base
  extend UhEntry
  ENTITY_OPTION = {:ref_id_name => "book_id", :include => "uha_book", :date_in_number => true, :date_field_str => "create_date"}
  
  belongs_to :uha_book, :foreign_key => 'book_id'
  set_inheritance_column :not_used # override the default 'type' name, since it is already used in our uha_book table of the uha.sqlite database

  define_index do
    indexes content
    indexes uha_book.name
    indexes uha_book.path
    
    has create_date
  end
  
  
  # get paginated annotations of given bookids within the interval specified by
  # start_time and end_time.
  def self.paginate_annotations_within_interval(opts={})
    self.paginate_entries_within_interval(ENTITY_OPTION, opts)
  end
    
  # get annotations made today
  def self.paginate_annotations_today(opts)
    self.paginate_entries_within_interval(ENTITY_OPTION, opts)
  end
  
  # get annotations made this week
  def self.paginate_annotations_a_week(opts)
    opts[:end_time] = Time.now
    self.paginate_entries_within_interval(ENTITY_OPTION, opts)
  end
  
  # get annotations made this month
  def self.paginate_annotations_a_month(opts)
    self.paginate_entries_within_interval(ENTITY_OPTION, opts)
  end
  
  # get annotations made this year
  def self.paginate_annotations_a_year(opts)
    self.paginate_entries_within_interval(ENTITY_OPTION, opts)
  end
end
