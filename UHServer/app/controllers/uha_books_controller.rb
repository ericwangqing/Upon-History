class UhaBooksController < ApplicationController
  before_filter :set_page_title
  
  def index
    @items =  UhaBook.paginate :page => params[:page], :order => "last_ann DESC", :per_page => 30
    @page_title = "UHA PDF Books"
  end
  
  def search
    @items = UhaAnnotation.search params[:search], :per_page => params[:per_page], :page => params[:page], :match_model => :boolean
    @item_name = "UHA Search Result with <b>#{params[:search]}</b>"
    @current_book = nil
    render :action => :show_annos
  end
  
  def show_annos
    bookids = get_bookids_from_param(params[:bookids])
    start_time = end_time = nil
    start_time = Time.at(params[:start_time].to_i) if !params[:start_time].nil?
    end_time = Time.at(params[:end_time].to_i) if !params[:end_time].nil?
    if (start_time.nil? && end_time.nil? && bookids.blank?)
      @items = UhaAnnotation.paginate_annotations_today(
              :page => params[:page],
              :per_page => 20)
    else
      @items = UhaAnnotation.paginate_annotations_within_interval(
                :ids => bookids, 
                :start_time => start_time, 
                :end_time => end_time,
                :page => params[:page],
                :per_page => 20)
    end
    
    if @items.empty?
      redirect_to_index "None of annotations made between #{start_time.to_s(:db)} and #{end_time || 'Now'} of books: #{params[:bookids] || 'All'}"
    end
    # set up instance variable @current_book for render using
    @current_book = nil
  end
  
  # DELETE /uha_books/1
  # DELETE /uha_books/1.xml
  def destroy
    @book = UhaBook.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to(uha_books_url) }
      format.xml  { head :ok }
    end
  end
  
  def remove_empty_anno_books
    all_books = UhaBook.find(:all)
#    empty_books = all_books.filter {|book| book.reload_annos_count = 0}
    empty_books = 0
    for book in all_books
      if book.reload_annos_count == 0
        book.destroy 
        empty_books += 1
      end
    end
    redirect_to_index "#{empty_books} Books without Annotations Removed."
  end
  
  def test_diigo
    DiigoBookmark.load_bookmarks_from_diigo
    redirect_to_index
  end
  
private
  
  # unmarshal bookids form comma separated string
  def get_bookids_from_param(bookid_string)
    if bookid_string.blank? 
      return []
    end
    return bookid_string.split(",")
  end
  
  def set_page_title
    @page_title = (params[:banner] || "").capitalize + " UHA Annotations"
  end
end
