class UsersController < ApplicationController
before_action :logged_in_user,only: [:edit,:update,:index,:destroy]
before_action :correct_user, only: [:edit,:update]
before_action :admin_user, only:[:destroy] 

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def create
    @user = User.new(user_params)#user_paramsは下にあるprivateメソッド
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email account to activate your account"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)#user_paramsは下にあるprivateメソッド
      flash[:success] = "Profile Updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.where(activated: true).paginate(page:params[:page])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  


  private 

    def user_params
      params.require(:user).permit(:name,:email,:password,
                              :password_confirmation)
    end

    #ここからbeforeアクション

    #ログインずみユーザーか確認、違ったらリダイレクト
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    #正しいユーザー確認＠useｒとcurrent_userが一致しているかかくにん
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
