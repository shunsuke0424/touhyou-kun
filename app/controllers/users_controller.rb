class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:detail, :show, :edit, :update,:ranking]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit, :update]}
  def index
    @users = User.where(disabled: false).all.order(updated_at: :desc)
  end

  def show
    @keywords = Keyword.all
    @user = User.where(disabled: false).find_by(id: params[:id])
    @grouped_keywords = @keywords.group_by {|k| k[:question]}
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name],
      password: params[:password],
      disabled: false
    )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/detail")
    else
      render("users/new")
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.update(disabled: true)
    session[:user_id] = nil
    flash[:notice] = "退会しました"
    redirect_to("/")
  end

  def edit
    @user = User.find_by(id: params[:id])
  end
  
  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    
    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end
  def detail
    @total_evaluators = Vote.where(voter_id: @current_user.id).pluck(:voted_id).uniq.count
    @total_evaluated = Vote.where(voted_id: @current_user.id).pluck(:voter_id).uniq.count
    @total_lovers = Like.where(liked_user_id: @current_user.id).count
  end
  
  def ranking
    @user = User.includes(:likes).where(disabled: false).find_by(id: params[:id])
    @votes_count = Vote.where(voted_id: @user.id).pluck(:voter_id).uniq.length
    @likes_count = Like.where(liked_user_id: @user.id).count
    create_result_hash
    @data = @final_params.map do |param|
      if param[:result]!=nil
        param[:result].map { |r| [r[:option], r[:ratio]] }.to_h
      end
    end
  end

  def create_result_hash
    @keywords=Keyword.includes(:votes).all
    @grouped_keywords = @keywords.group_by {|k| k[:question]}
    questions = Keyword.select(:question).distinct
    @final_params = questions.map do |question|
      grouped_keyword_by_question = @grouped_keywords[question.question]
      grouped_keyword_by_question_ids = grouped_keyword_by_question.pluck(:id)
      result_count_hash = Vote.includes(:votes).where(voted_id: @user.id).where(keyword_id: grouped_keyword_by_question_ids).group(:keyword_id).size
      if result_count_hash.size !=0
        result_count_array = result_count_hash.values
        total = result_count_array.sum
        result_hash = grouped_keyword_by_question.map do |keyword|
          count = result_count_hash[keyword.id]
          ratio = count.to_i * 100 / total
          {
            option: keyword.option,
            ratio: ratio
          }
        end
        {
          question: question.question,
          result: result_hash
        }
      else
        {
          question: question.question
        }
      end
    end
  end

  def login_form
  end
  
  def create_guest_user
    @user = User.new(
      name: "ゲストユーザ"+rand(8888).to_s,
      password: "ゲストユーザ"+rand(8888).to_s
    )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ゲストとしてログインしました"
      redirect_to("/users/index")
    else
      render("users/new")
    end
  end

  def login
    @user = User.where(disabled: false).find_by(name: params[:name])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/detail")
    else
      @error_message = "ユーザ名またはパスワードが間違っています"
      @name = params[:name]
      @password = params[:password]
      render("users/login_form")
    end
  end

  
  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end
end
