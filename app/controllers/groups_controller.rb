class GroupsController < ApplicationController
  before_action :authenticate_user, {only: [:index, :show, :create]}
  before_action :ensure_correct_user, {only: [:edit, :update]}
  def index
    @groups = @current_user.groups
  end
  def show
    group = Group.find_by(id_token: params[:id_token])
    return redirect_to("/groups/index"),flash[:notice] = "グループが見つかりません" unless group
    
    @users = group.users
  end

  def create
    id_token = SecureRandom.hex(16)
    @group = Group.create(
      name: params[:name],
      id_token: id_token
    )
    @current_user.member_ships.build(group: @group)
    if @current_user.save
      flash[:notice] = "グループを作成しました"
      redirect_to("/groups/#{@group.id_token}")
    else
      redirect_to("/create_group")
    end
  end
  
  def create_form
  end

  def join_form
    @group = Group.find_by(id_token: params[:id_token]) if params[:id_token]
  end

  # TODO:リダイレクト系まだやってない
  def join
    group = Group.find_by(id_token: params[:id_token])
    return redirect_to("/"),flash[:notice] = "グループが見つかりません" unless group
    
    if @current_user
      @current_user.member_ships.build(group: group)
      if @current_user.save
        flash[:notice] = "グループに参加しました"
        redirect_to("/groups/#{group.id_token}")
      else
        redirect_to("/")
      end
    else
      return redirect_to("/?id_token=#{group.id_token}")
    end
  end

  def top
    @group = Group.find_by(id_token: params[:id_token])
    if !@group
      redirect_to("/join_group")
      flash[:notice] = "URLが正しくありませんでした"
    elsif @current_user
      redirect_to("/join_group?id_token=#{@group.id_token}")
    end
  end

  def all_create
    group = Group.find_by(id_token: params[:id_token])
    return redirect_to("/"),flash[:notice] = "グループが見つかりません" unless group
    
    @user = User.find_by(name: params[:name])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
    else
      @user = User.create!(
        name: params[:name],
        password: params[:password]
      )
    end
    @user.member_ships.build(group: group)
    if @user.save!
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録とグループ参加が完了しました"
      redirect_to("/groups/#{group.id_token}")
    else
      flash[:notice] = "エラーが発生しました"
      render("/signup")
    end
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end
end
