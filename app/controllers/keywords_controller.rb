class KeywordsController < ApplicationController
  def new
    @keyword = Keyword.new
  end

  def create
    @keyword = Keyword.find_by(id: params[:keyword_id])
    @user = User.find_by(id: params[:user_id])
    @keyword.user_keywords.build(user: @user)
    @keyword.save
  end

  def destroy
    @keyword = Keyword.find_by(id: params[:keyword_id])
    @user = User.find_by(id: params[:user_id])
    @user_keywords = UserKeyword.find_by(user_id: params[:user_id], keyword_id: params[:keyword_id])
    @user_keywords.destroy
  end
end