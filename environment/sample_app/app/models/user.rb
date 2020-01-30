class User < ApplicationRecord
    before_save { self.email = email.downcase }
    validates :name,presence: true, length:{ maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email,presence: true, length:{ maximum: 255 },
                            format: { with: VALID_EMAIL_REGEX },
                            uniqueness: { case_sensitive: false}
    has_secure_password
    validates :password, presence: true,length: { minimum: 6 }

    #渡された文字列のハッシュ値を返すメソッド。password_digest属性をfixtureに追加するため。
    def User.digest(string)#Userのクラスメソッド。何にでも使うから。
        #cost はハッシュを算出するための計算コスト。二行目で使う。ミニマムにしてある
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
        #引数のハッシュ値を計算してreturn.
        BCrypt::Password.create(string, cost: cost)
    end



end
