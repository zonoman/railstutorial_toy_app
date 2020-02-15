# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true # このオプションを追加するのなら、そもそもこのvalidationは必要？

  # 渡された文字列bのハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    # rubocop:disable Rails/SkipsModelValidations
    update_attribute(:remember_digest, User.digest(remember_token))
    # rubocop:enable Rails/SkipsModelValidations
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, remember_token)
    remember_digest = send("#{attribute}_digest") # ("remember_digest")
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    # rubocop:disable Rails/SkipsModelValidations
    update_attribute(:remember_digest, nil)
    # rubocop:enable Rails/SkipsModelValidations
  end

  # アカウントを有効にする
  def activate
    # rubocop:disable Rails/SkipsModelValidations
    update_attribute(activated: true, activated_at: Time.zone.now)
    # rubocop:enable Rails/SkipsModelValidations
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    # rubocop:disable Rails/SkipsModelValidations
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
    # rubocop:enable Rails/SkipsModelValidations
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  private

  def downcase_email
    email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
