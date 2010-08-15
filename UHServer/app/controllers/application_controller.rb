# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_tags_cloud
  layout "uhserver"
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  @@tags_cloud_cache = nil # cache shuffled first 50 DiigoTags

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
protected

  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end
  
  def set_tags_cloud
    @@tags_cloud_cache = DiigoTag.tags_cloud[0..49].shuffle if @@tags_cloud_cache.blank?
    @tags = @@tags_cloud_cache
  end
end
