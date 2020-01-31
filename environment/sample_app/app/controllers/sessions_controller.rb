class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email:params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user#sessionshelperのヘルパーメソッド。idをcokkieに保存する
      remember user#sessionshelperのヘルパーメソッド。記憶トーキンのdigestをDBに保存、
      redirect_to user#→user_url(user)
    else
      #エラーメッセージを作成する
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end

  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
