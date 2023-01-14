module Admin
  class UsersController < BaseController
    def index
      @users = User.order(updated_at: :desc)
    end
    
    def show
      @user = User.includes(:likes).where(disabled: false).find_by(id: params[:id])
      @votes_count = Vote.where(voted_id: @user.id).pluck(:voter_id).uniq.length
      @likes_count = Like.where(liked_user_id: @user.id).count
    end
    
    def edit
      @user = User.find_by(id: params[:id])
    end

    def update
      @user = User.find_by(id: params[:id])
      @user.name = params[:name]
      @user.disabled = params[:disabled]
      @user.admin = params[:admin]
      
      if @user.save
        flash[:notice] = "ユーザー情報を編集しました"
        redirect_to("/admin/users/index")
      else
        render("admin/users/edit")
      end
    end

    def destroy
      @user = User.find_by!(id: params[:id])
      Vote.where(voter_id: @user.id).destroy_all
      Vote.where(voted_id: @user.id).destroy_all
      Like.where(like_user_id: @user.id).destroy_all
      Like.where(liked_user_id: @user.id).destroy_all
      @user.destroy!
      flash[:notice] = "削除しました"
      redirect_to("/admin/users/index")
    rescue ActiveRecord::RecordNotFound => e
      @error_message = "ユーザが見つかりません"
      redirect_to("/admin/users/index")
    end

    private

    def controller_action_authrized?
      return unless @current_user
      @current_user.admin?
    end
  end
end
