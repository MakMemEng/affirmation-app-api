require "validator/email_validator"

class User < ApplicationRecord
  # Token生成モジュール
  include TokenGenerateService

  before_validation :downcase_email

  has_secure_password
  attachment :profile_image

  has_many :posts, dependent: :destroy

  VALID_PASSWORD_REGEX = /\A[\w\-]+\z/

  validates :profile,  length: { maximum: 300 }

  with_options presence: true do
    validates :name,  length: {
                        maximum: 30,
                        allow_blank: true
                      }
    validates :email,     email: { allow_blank: true }
    validates :password,  length: {
                            minimum: 8,
                            allow_blank: true
                          },
                          format: {
                            with: VALID_PASSWORD_REGEX,
                            message: :invalid_password,
                            allow_blank: true
                          },
                          allow_nil: true
  end

  ## methods
  # class method  ###########################
  class << self
    # emailからアクティブなユーザーを返す
    def find_by_activated(email)
      find_by(email: email, activated: true)
    end
  end
  # class method end #########################

  # 自分以外の同じemailのアクティブなユーザーがいる場合にtrueを返す
  def email_activated?
    users = User.where.not(id: id)
    users.find_by_activated(email).present?
  end

  private
    # email小文字化
    def downcase_email
      self.email.downcase! if email
    end
end
