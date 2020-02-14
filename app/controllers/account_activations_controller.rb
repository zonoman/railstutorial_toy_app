class AccountActivationsController < ApplicationController

    def edit
        user = User.find_by(email: params[:email])
        if user && !user.activated? && user.authenticated?(:activation,params[:id])
            #!user.authenticated?は既に有効になっているユーザーを誤って再度有効化しないために必要です
            user.activate
            log_in user
            
            flash[:success] = "Account activated!"
            redirect_to user
        else
            flash[:danger] = "Invalid activation link"
            redirect_to root_url
        end
    end

end
