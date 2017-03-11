class User < ApplicationRecord
  attr_accessor :remember_token
  before_save :email_downcase
  has_many :courts, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :username, presence: true,
                       length: { maximum: 50}
  VALID_EMAIL_REGEX= /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    length: { maximum: 255 }, 
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, allow_nil: true
  validates_confirmation_of :password, allow_nil: true

  # ENCRYPT THE STRING, USING MINIMAL COST IF POSSIBLE
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # GENERATE NEW TOKEN
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # SAVE THAT TOKEN AS A VIRTUAL ATTRIBUTE, ENCRYPT ITS COPY AND SAVE IT IN DIGEST
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # CHECK IF REMEMBER DIGEST AND TOKEN ARE THE SAME
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # FORGET THE DIGEST
  def forget
    update_attribute(:remember_digest, nil)
  end

  # BEFORE SAVING CHANGE ALL CHARACTERS TO LOWERCASE
  def email_downcase
    self.email = email.downcase 
  end
end
