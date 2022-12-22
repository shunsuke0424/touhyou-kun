class UserKeywordsController < ApplicationController
  def create
    @keyword = UserKeyword.new(user_id: params[:user_id], keyword_id: params[:keyword_id])
    @keyword.save
  end
  
  def
    params.require(:user_keywords).permit(:user_id, :keyword_id)
  end

  def destroy
    @keyword = UserKeyword.new(user_id: params[:user_id], keyword_id: params[:keyword_id])
    @keyword.destroy
  end
end
