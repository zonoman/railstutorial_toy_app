class UsersController < ApplicationController
before_action :logged_in_user,only:[:index,:edit, :update]
before_action :correct_user, only:[:edit,:update]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(page:params[:page])
  end


  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "User created"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    #strongparameterを使用して、マスアサインメントの脆弱性を防止している
    if @user.update_attributes(user_params)
     flash[:success] = "Profile Updated" 
      redirect_to @user
    else
      render "edit"
    end
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in"
      redirect_to login_url
    end
  end

  #正しいユーザーか確認
  def correct_user
    @user =User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user) 
  end






  private 

    def user_params
      params.require(:user).permit(:name,:email,:password,
                              :password_confirmation)
    end



end
