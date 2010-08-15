class DiigoBookmark < ActiveRecord::Base
  # load 100 bookmarks recently from diigo, since no more can be retrieved by Diigo's API limit
  DIIGO_REST_URL = 'http://ericwangqing:txwdjsw@api2.diigo.com/bookmarks?rows=100&sort=0&users=ericwangqing'
  
  
  has_many :diigo_comments, :dependent => :destroy
  has_many :diigo_annotations, :dependent => :destroy
  has_and_belongs_to_many :diigo_tags
 
  def self.load_bookmarks_from_diigo
    
    return if updated_within_one_day?
    
    time_recorded = last_diigo_updated_time
    
    for bookmark in get_diigo_bookmarks DIIGO_REST_URL
      if Time.parse(bookmark["updated_at"]) < time_recorded
        puts "pass bookmark updated at #{bookmark["updated_at"]}"
        next
      end
      diigo_bookmark = DiigoBookmark.find_by_url(bookmark["url"], :include => :diigo_tags) || DiigoBookmark.new
      diigo_bookmark.title = bookmark["title"]
      diigo_bookmark.url = bookmark["url"]
      diigo_bookmark.desc = bookmark["desc"]
      diigo_bookmark.diigo_created_at = bookmark["created_at"]
      diigo_bookmark.diigo_updated_at = bookmark["updated_at"]
      
      if !bookmark["annotations"].nil?
        for anno in bookmark["annotations"]
          if !diigo_bookmark.diigo_annotations.find_by_content(anno["content"]).blank?
            next
          end
          
          diigo_annotation = DiigoAnnotation.new
          diigo_annotation.content = anno["content"]
          diigo_annotation.diigo_created_at = anno["created_at"]
          
          diigo_bookmark.diigo_annotations << diigo_annotation
        end
      end
      
      if !bookmark["comments"].blank?
        for comment in bookmark["comments"]
          if !diigo_bookmark.diigo_comments.find_by_content(comment["content"]).blank?
            next
          end
          
          diigo_comment = DiigoComment.new
          diigo_comment.content = comment["content"]
          diigo_comment.diigo_created_at = comment["created_at"]
          
          diigo_bookmark.diigo_comments << diigo_comment
        end
      end
      
      if !bookmark["tags"].blank? and bookmark["tags"] != "no_tag"
        for tag in bookmark["tags"].split(',')
          diigo_tag = DiigoTag.find_or_create_by_name(tag)
          if diigo_bookmark.diigo_tags.include? diigo_tag
            next
          end
          diigo_bookmark.diigo_tags << diigo_tag
        end
      end
      diigo_bookmark.save 
    end
    
    record_last_updated_time_in_db
  end
  
  
  def notes_count
    @notes_count ||= DiigoAnnotation.count(:conditions => ["diigo_bookmark_id = ?", id]) +
                     DiigoComment.count(:conditions => ["diigo_bookmark_id = ?", id])
  end
  
  def reload_notes_count
    @notes_count = DiigoAnnotation.count(:conditions => ["diigo_bookmark_id = ?", id]) +
                     DiigoComment.count(:conditions => ["diigo_bookmark_id = ?", id])
  end
  
  def retrieve_comments
    DiigoBookmark.find(id, :include => :diigo_comments).diigo_comments
  end

private
  
  def self.updated_within_one_day?
    last_anno = DiigoAnnotation.find(:first, {:order => "updated_at DESC"})
    if last_anno.blank?
      last_updated = 2.days.ago
    else
      last_updated = last_anno.updated_at
    end
    return last_updated > 1.days.ago
  end

  def self.last_diigo_updated_time
    # only updated_time later than all bookmarks in our db will be added or updated
    last_bookmark = DiigoBookmark.find(:first, {:order => "diigo_updated_at DESC"})
    if last_bookmark.blank?
      last_diigo_updated = 3.years.ago
    else
      last_diigo_updated = last_bookmark.diigo_updated_at
    end
    last_diigo_updated
  end
  
  # get Diigo bookmarks from given diigo_rest_url
  # return JSON hash
  def self.get_diigo_bookmarks(diigo_rest_url)
    require 'rubygems'
    require 'rest_client'
#    require 'socksify'
#    TCPSocket::socks_server = "127.0.0.1"
#    TCPSocket::socks_port = 8580
    
    RestClient.proxy = "http://127.0.0.1:8580"

    response = RestClient.get diigo_rest_url
    ActiveSupport::JSON.decode(response)
  end
  
  def self.record_last_updated_time_in_db
    # update one annotation with current time in its updated_at field
    # to mark this update for next time
    last_anno = DiigoAnnotation.find(:first, {:order => "updated_at DESC"})
    last_anno.updated_at_will_change!
    last_anno.save
  end
  
end
