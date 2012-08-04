class UserController < ApplicationController
  def new
    @user = User.find_by_name(params[:name])
    redirect_to player_url(:id => @user.id) and return if @user
    @user = User.new
    @user.name = params[:name]
    @user.save!
    render :new_player
  end

  def show
    @user = User.find(params[:id])
    render :recurrent_player
  end

end
