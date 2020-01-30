module SessionsHelper

    #cokkieにidを記憶させるためのメソッド
    def log_in(user)
        #一時cookiesに、暗号化ずみのuser.idを生成してくれる事前定義ずみメソッド。
        #ブラウザを閉じると消える。
        session[:user_id]= user.id
    end

    #今ログインしてるuser. current_user.name みたいな感じで使いたい。
    #誰もログインしていなかったらnilを返す
    def current_user
        if session[:user_id]
        #User.find(session[:user_id]だと例外が発生して困るので)
        #User.find_by(id:session[:user_id]にしている)
        #@current_user = @current_user || User.find_by(id:session[:user_id])
        @current_user ||= User.find_by(id: session[:user_id])
        end

    end

    #ユーザーがログインしていればtrue,していなければfalsを返すメソッド。
    def logged_in?
        !current_user.nil?
    end



end
