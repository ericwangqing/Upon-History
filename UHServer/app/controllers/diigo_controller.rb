class DiigoController < ApplicationController
  before_filter :set_page_title
  
  def index
    find_all_bookmarks
  end
  
  def search
    @items = DiigoAnnotation.search params[:search], :per_page => params[:per_page], 
                        :page => params[:page], :match_model => :boolean, :field_weight => {
                          :tag => 20,
                          :title => 15,
                          :content => 10,
                          :desc => 10
                        }
    @item_name = "Diigo Search Results with <b>#{params[:search]}</b>"
    @current_bookmark = nil
    render :action => :show_notes
  end
  
  def destory
    bookmark = DiigoBookmark.find(params[:id])
    bookmark.destory if !bookmark.blank?
    find_all_bookmarks
    redirect_to_index 
  end
  
  def show_notes
    # since annotations are much more than comments, we only retrieve annos (@items)
    # and get corresponding comments via bookmark in rendering
    
    bookmarkids = get_bookmarkids_from_param(params[:bookmarkids])
    start_time = end_time = nil
    start_time = Time.at(params[:start_time].to_i) if !params[:start_time].nil?
    end_time = Time.at(params[:end_time].to_i) if !params[:end_time].nil?
    if (start_time.nil? && end_time.nil? && bookmarkids.blank?)
            
      @items = DiigoAnnotation.paginate_annotations_today(
              :page => params[:page],
              :per_page => 20)
              
    else
      @items = DiigoAnnotation.paginate_annotations_within_interval(
                :ids => bookmarkids, 
                :start_time => start_time, 
                :end_time => end_time,
                :page => params[:page],
                :per_page => 20)
    end
    
    if @items.empty?
      redirect_to_index "None of annotations made between #{start_time.to_s(:db) if !start_time.blank?} and #{end_time || 'Now'} of bookmarkids: #{params[:id] || 'All'}"
    end
    
    # set up instance variable @current_bookmark for render using
    @item_name = "Diigo Notes"
    @current_bookmark = nil
  end
  
  def show_notes_with_tag
    redirect_to_index "no tag selected." if params[:tag].blank?
    tag = DiigoTag.find_by_name(params[:tag])
    @items = DiigoAnnotation.paginate :all, :page => params[:page], :include => :diigo_bookmark, 
                                :order => "diigo_annotations.diigo_bookmark_id, diigo_annotations.updated_at DESC", :per_page => 20, 
                                :conditions => ["dd.diigo_tag_id = ?", tag.id],
                                :joins => "join diigo_bookmarks_diigo_tags as dd on diigo_annotations.diigo_bookmark_id = dd.diigo_bookmark_id"
    @item_name = "Diigo Notes on <b>#{tag.name}</b>"
    render :action => :show_notes
  end
  
  def show_tags
    @tags = DiigoTag.tags_cloud
    @page_title = "Diigo Tags"
  end

private
  def find_all_bookmarks
    DiigoBookmark.load_bookmarks_from_diigo
    @items =  DiigoBookmark.paginate :page => params[:page], :include => :diigo_tags, :order => "diigo_updated_at DESC", :per_page => 30
    @item_name = "Diigo bookmarks"
  end
  
  def get_bookmarkids_from_param(bookmarkid_string)
    if bookmarkid_string.blank? 
      return []
    end
    return bookmarkid_string.split(",")
  end
  
  def set_page_title
    @page_title = (params[:banner] || "").capitalize + " Diigo Bookmarks"
  end
end
