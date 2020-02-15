# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :set_user, only: :create

  def new; end

  def create
    (render('new') && return) unless @user&.authenticate(params[:session][:password])

    if @user.activated?
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash[:warning] = 'Account not activated. Check your email for the activation link.'
      redirect_to root_url
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def set_user
    @user = User.find_by(email: params[:session][:email].downcase)
  end
end
