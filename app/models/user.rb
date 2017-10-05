class User < ApplicationRecord

	has_many :user_emails
  # validates :email, presence: true, length: {maximum: 60}, email: true, uniqueness: true
  validates :fax_number, presence: true, length: {maximum: 60}, phone: {possible: true}
  validates :password, length: { in: 6..32 }, presence: true

  has_secure_password

  before_save :format_fax_number

  private

    def format_fax_number
      self.fax_number = Phonelib.parse(fax_number).e164
    end
end
