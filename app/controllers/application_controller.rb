# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # sessionコントローラーを生成した段階で自動生成されたヘルパーモジュール。
  # ここで読み込ませることによって、全コントろーラーで使える。
  include SessionsHelper

  private

  # ユーザーのログインを確認する
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end
end
