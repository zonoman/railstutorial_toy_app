class User < ApplicationRecord
    attr_accessor :remember_token
    before_save { self.email = email.downcase }
    validates :name,presence: true, length:{ maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email,presence: true, length:{ maximum: 255 },
                            format: { with: VALID_EMAIL_REGEX },
                            uniqueness: { case_sensitive: false}
    has_secure_password
    validates :password, presence: true,length: { minimum: 6 }

    class << self
        #渡された文字列のハッシュ値を返すメソッド。password_digest属性をfixtureに追加するため。
        def digest(string)#Userのクラスメソッド。何にでも使うから。
            #cost はハッシュを算出するための計算コスト。二行目で使う。ミニマムにしてある
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
            #引数のハッシュ値を計算してreturn.
            BCrypt::Password.create(string, cost: cost)
        end

        #ランダムなトークンを作る
        def new_token
            SecureRandom.urlsafe_base64
        end

    end

    #記憶トークンをnew_tokenメソッドで作成し、そのだいじぇすとをDBにい保存。
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest,User.digest(remember_token))
    end

    #わたされたトークンがダイジェストと一致したらtrueを返す
    #このremember_token は、アクセサ（:remember_token）とは別物
    def authenticated?(remember_token)
        return false if remember_digest.nil?#ブラウザニコ使用時のバグ対策
        Bcrypt::password.new(remember_digest).is_password?(remember_token)
    end

    #ユーザーのログイン情報を破棄する
    def forget 
        update_attribute(:remember_digest,nil)
    end
end
