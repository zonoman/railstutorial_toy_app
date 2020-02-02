ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  #sessionsHelperのlogged_in?がテストでは使えないので、同じ効果のものをここで定義。
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user)
    session[:user_id] = user.id
  end


  # Add more helper methods to be used by all tests here...
end

#integrationTestで使うヘルパーなので、ActionDipatchを定義する
class ActionDispatch::IntegrationTest

  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path,params: { session: { email: user.email,
    password: password,
    remember_me: remember_me } }
  end
  




end
