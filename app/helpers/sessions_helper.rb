# frozen_string_literal: true

module SessionsHelper
  # cokkieにidを記憶させるためのメソッド
  def log_in(user)
    # 一時cookiesに、暗号化ずみのuser.idを生成してくれる事前定義ずみメソッド。
    # ブラウザを閉じると消える。
    session[:user_id] = user.id
  end

  # ユーザーのsessioｎを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user?(user)
    user == current_user
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if session[:user_id]
      # User.find(session[:user_id]だと例外が発生して困るので),User.find_by(id:session[:user_id]にしている)
      # @current_user = @current_user || User.find_by(id:session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id]) # ←「(ユーザーIDにユーザーIDのセッションを代入した結果) ユーザーIDのセッションが存在すれば」
      user = User.find_by(id: user_id)
      if user&.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue,していなければfalsを返すメソッド。
  def logged_in?
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 記憶したURL（もしくはデフォルト値）にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
    # request.original_urlでリクエスト先が取得できます
  end
end
