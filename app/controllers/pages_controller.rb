class PagesController < ApplicationController
  layout "referenz"

  skip_before_filter :login_required, :only => [:index, :show, :draft]

  make_resourceful do
    build :all
    
    before :create do
      @page.user = current_user
    end

    before :index, :new, :show do
      @categories = Category.find :all
    end
    
    before :new, :show do
      @pages = current_objects
    end
  end

  def publish
    load_object
    current_object.toggle! :published
    respond_to do |format|
      format.js  # rendert publish.rjs
      format.html { redirect_to page_path(current_object) }
    end
  end
  
  def current_objects
    Page.find :all, :order => 'title ASC'
  end
end
