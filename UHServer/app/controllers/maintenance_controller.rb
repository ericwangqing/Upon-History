class MaintenanceController < ApplicationController
  def diigo
    DiigoBookmark.load_bookmarks_from_diigo
    render :text => "Diigo bookmarks loaded."
  end
end
