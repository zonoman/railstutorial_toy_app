class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  #sessionコントローラーを生成した段階で自動生成されたヘルパーモジュール。
  #ここで読み込ませることによって、全コントろーラーで使える。
  include SessionsHelper

  
  def hello
    render html: "hello world!!"
  end
end

