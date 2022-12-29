class LikesController < ApplicationController

  def create
    @user = User.find_by(id: params[:liked_user_id])
    @like = Like.new(like_user_id: @current_user.id, liked_user_id: params[:liked_user_id])
    @like.save
  end

  def destroy
    @user = User.find_by(id: params[:liked_user_id])
    @like = Like.find_by(like_user_id: @current_user.id, liked_user_id: params[:liked_user_id])
    @like.destroy
  end
end
