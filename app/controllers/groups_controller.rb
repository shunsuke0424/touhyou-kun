class GroupsController < ApplicationController
  before_action :authenticate_user, {only: [:index, :show, :create, :join]}
  before_action :ensure_correct_user, {only: [:edit, :update]}
  def index
    @groups = @current_user.groups
  end
  def show
    @group = Group.find_by(id_token: params[:id_token])
    return redirect_to("/groups/index"),flash[:notice] = "グループが見つかりません" unless @group
    
    @users = @group.users.where(disabled: false)
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
    return redirect_to("/join_group"),flash[:notice] = "グループが見つかりません" unless group
    
    return redirect_to("/groups/#{group.id_token}"),flash[:notice] = "すでに参加しています" if @current_user.groups.include?(group)
    
    if @current_user
      @current_user.member_ships.build(group: group)
      if @current_user.save!
        flash[:notice] = "グループに参加しました"
        redirect_to("/groups/#{group.id_token}")
      else
        redirect_to("/join_group")
      end
    else
      return redirect_to("/invite?id_token=#{group.id_token}")
    end
  end

  def login_join_form
    @group = Group.find_by(id_token: params[:id_token])
    if !@group
      redirect_to("/join_group")
      flash[:notice] = "正しいグループIDを入力してください"
    elsif @current_user
      redirect_to("/join_group?id_token=#{@group.id_token}")
    end
  end

  def signup_join_form
    @group = Group.find_by(id_token: params[:id_token])
    if !@group
      redirect_to("/join_group")
      flash[:notice] = "正しいグループIDを入力してください"
    elsif @current_user
      redirect_to("/join_group?id_token=#{@group.id_token}")
    end
  end

  def login_join
    group = Group.find_by(id_token: params[:id_token])
    return redirect_to("/users/login_form"),flash[:notice] = "グループが見つかりません" unless group
    
    @user = User.where(disabled: false).find_by(name: params[:name])
    if !@user || !@user.authenticate(params[:password])
      flash[:notice] ="ユーザ名またはパスワードが間違っています"
      redirect_to("/login_join_form/#{group.id_token}")
      return
    end
    
    session[:user_id] = @user.id
    return redirect_to("/groups/#{group.id_token}"),flash[:notice] = "すでに参加しています" if @user.groups.include?(group)

    @user.member_ships.build(group: group)
    if @user.save
      flash[:notice] = "グループに参加しました"
      redirect_to("/groups/#{group.id_token}")
    else
      flash[:notice] = "エラーが発生しました"
      redirect_to("/login_join_form/#{group.id_token}")
    end
  end

  def signup_join
    group = Group.find_by(id_token: params[:id_token])
    return redirect_to("/signup"),flash[:notice] = "グループが見つかりません" unless group
    
    @user = User.create!(
      name: params[:name],
      password: params[:password],
      disabled: false
    )
    @user.member_ships.build(group: group)
    if @user.save!
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録とグループ参加が完了しました"
      redirect_to("/groups/#{group.id_token}")
    else
      flash[:notice] = "エラーが発生しました"
      redirect_to("/signup_join_form/#{group.id_token}")
    end
  end
  
  def invite
    @group = Group.find_by(id_token: params[:id_token])
    if !@group
      redirect_to("/")
      flash[:notice] = "正しいグループIDを入力してください"
    elsif @current_user
      redirect_to("/join_group?id_token=#{@group.id_token}")
    end
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end
end
