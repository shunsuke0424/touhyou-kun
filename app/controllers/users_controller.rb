class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:show, :edit, :update]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit, :update]}
  def index
    @users = User.all.order(updated_at: :desc)
  end
  
  def show
    @keywords = Keyword.all
    @user = User.find_by(id: params[:id])
    @grouped_keywords = @keywords.group_by {|k| k[:question]}
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password]
    )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/")
    else
      render("users/new")
    end
  end
  
  def edit
    @user = User.find_by(id: params[:id])
  end
  
  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    
    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end
  
  def ranking
    @user = User.find_by(id: params[:id])
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
  
  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    @current_user = nil
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
