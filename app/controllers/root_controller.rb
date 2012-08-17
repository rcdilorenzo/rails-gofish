class RootController < ApplicationController
  # index.erb
  def index
    render :graphics
  end

  def drawing
    puts params
    render :text => ''
  end
end
