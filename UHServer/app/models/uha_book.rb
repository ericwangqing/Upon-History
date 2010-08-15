class UhaBook < ActiveRecord::Base
  set_table_name 'uha_book'
  

  attr_accessor :title, :link_url
  has_many :uha_annotations, :dependent => :destroy, :foreign_key => 'book_id'
  
  def showable?
    return (!name.blank? and !uha_annotations.empty? and uha_annotations.size > 0)
  end
  
  def title
    if !name.blank? 
      return name
    end
    if path.blank?
      return id
    end
    return path.split("/").last  
  end
  
  def link_url
    if path.blank?
      return "#"
    end
    tokens = path.split("/")
    driver = tokens[1]
    return "file:///" + driver + ":/" + tokens[2..tokens.size].join("/")
  end
  
  def annos_count
    @annos_count ||= UhaAnnotation.count :conditions => ["book_id = ?", id]
  end
  
  def reload_annos_count
    @annos_count = UhaAnnotation.count :conditions => ["book_id = ?", id]
  end
end
