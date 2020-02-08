class User < ApplicationRecord
    attr_accessor :remember_token,:activation_token
    before_save :downcase_email
    before_create :create_activation_digest
    validates :name,presence: true, length:{ maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email,presence: true, length:{ maximum: 255 },
                            format: { with: VALID_EMAIL_REGEX },
                            uniqueness: { case_sensitive: false}
    has_secure_password
    validates :password, presence: true,length: { minimum: 6 },allow_nil: true #has_secure_passwordでvakidateされるので、allownil

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
   
    #def authenticated?(remember_token)
        #return false if remember_digest.nil?#ブラウザニコ使用時のバグ対策
        #BCrypt::Password.new(remember_digest).is_password?(remember_token)
    #end

    #上のやつの抽象化版。リスと11.26
    #トークンがダイジェストと一致したらtrueを返す
    def authenticated?(attribute,token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end


    #ユーザーのログイン情報を破棄する
    def forget 
        update_attribute(:remember_digest,nil)
    end

    #アカウントを有効にする
    def activate
        update_columns(activated: true, activated_at: Time.zone.now)
    end

    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest,User.digest(reset_token))
        update_attribute(:reset_sent_at,Time.zone.now)
    end

    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
    

    private
        def downcase_email
            self.email.downcase!
        end

        def create_activation_digest
            self.activation_token  = User.new_token
            self.activation_digest = User.digest(activation_token)
          end

end
