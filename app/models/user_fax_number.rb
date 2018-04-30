class UserFaxNumber < ApplicationRecord
	belongs_to :user

  validates :fax_number, length: {maximum: 60}, phone: {possible: true}, presence: true

	before_save :format_fax_number

	 private

    def format_fax_number
      self.fax_number = Phonelib.parse(fax_number).e164
    end
end
