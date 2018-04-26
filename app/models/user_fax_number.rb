class UserFaxNumber < ApplicationRecord

	has_many :user_emails
	has_many :users, through: :user_emails

  validates :fax_number, presence: true, length: {maximum: 60}, phone: {possible: true}

	before_save :format_fax_number

	 private

    def format_fax_number
      self.fax_number = Phonelib.parse(fax_number).e164
    end
end
