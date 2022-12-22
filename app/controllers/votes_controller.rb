class VotesController < ApplicationController
  def create
    @votes=Keyword.all
    @vote = Vote.new
    @keyword = Keyword.find_by(id: params[:keyword_id])
    @voter = User.find_by(id: params[:voter_id])
    @user = User.find_by(id: params[:voted_id])
    @vote.voter_id = @voter.id
    @vote.voted_id = @user.id
    @vote.keyword_id = @keyword.id
    @vote.save
    @linked_keywords = Vote.where(voter_id: @current_user.id, voted_id: @user.id ).pluck(:keyword_id)
    redirect_to("/users/#{params[:voted_id]}")
  end
  
  def vote_params
    params.require(:vote).permit(:voter_id, :voted_id, :keyword_id)
  end

  def destroy
    @keyword = Keyword.find_by(id: params[:keyword_id])
    @user = User.find_by(id: params[:voted_id])
    @vote = Vote.find_by(voter_id: params[:voter_id], voted_id: params[:voted_id], keyword_id: params[:keyword_id])
    @vote.destroy
    redirect_to("/users/#{params[:voted_id]}")
  end
end