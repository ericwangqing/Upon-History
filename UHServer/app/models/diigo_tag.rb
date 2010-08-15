class DiigoTag < ActiveRecord::Base
  has_and_belongs_to_many :diigo_bookmarks
  attr_accessor :weight # for tag could use only
  
  @@tags_cloud_cache = nil # cache tags cloud
  
  def self.tags_cloud(all=false)
    if @@tags_cloud_cache.blank?
      # get the most used 50 tags with weight for rendering as tags-cloud
      tags_cloud = self.find_by_sql("select t.name, count(t.name) as amount from diigo_bookmarks_diigo_tags as d " +
                               "join diigo_tags as t on d.diigo_tag_id = t.id group by diigo_tag_id order by amount DESC")
      most_used_tag_bookmarks = tags_cloud.collect{|t| t.amount}.max()
      per_tagged_bookmarks = tags_cloud.sum(&:amount) / tags_cloud.size.to_f
      tags_cloud.each do |tag|
        tag.weight = caculate_weight(tag.amount, per_tagged_bookmarks, most_used_tag_bookmarks)
      end
      @@tags_cloud_cache = tags_cloud
    end
    @@tags_cloud_cache
  end

  def amount
    attributes["amount"].to_i
  end
  
private

  def self.caculate_weight(bookmarks, avg, max)
    # scale bookmarks more than avg into 10 ... 3, and
    # less than avg into 1 ... 3
    upper_scale = 7 * avg / max 
    if bookmarks > avg
      return (bookmarks * upper_scale / avg).floor + 3
    else
      return (bookmarks / (avg/3)).to_i
    end
  end
end
