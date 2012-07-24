class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    if current_user.friends
      @entries = current_user.timeline
    else
      @entries = Entry.all
    end
    render :json => @entries.to_json(:include => [:user])
  end

  def search
    User.current_user = current_user
    @users = User.username_search(params[:id])
    render :json => @users.to_json(:methods => :follow?)
  end

  def follow
    @user = User.find_by_id(params[:id])
    if @user == current_user
      p "current user"
      render status: 404, nothing: true and return
    elsif current_user.friends.exists?(@user.id)
      p "unfollow"
      current_user.friends.delete(@user)
      render :json => @user.to_json(:methods => :follow?) and return
    elsif current_user.friends << @user
      p "followed"
      render :json => @user.to_json(:methods => :follow?) and return
    else
      p "nothing"
      render status: 404, nothing: true and return
    end
  end

  def user
    User.current_user = current_user
    @user = User.find_by_id(params[:id])
    render :json => @user.to_json(
      :methods => [:follow?, :entries_count, :friends_count, :followers_count],
      :include => :entries)
  end

end
