class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email:params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user#sessionshelperのヘルパーメソッド。idをcokkieに保存する
      redirect_to user#→user_url(user)
    else
      #エラーメッセージを作成する
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end

  end

  def destroy
  end


end
