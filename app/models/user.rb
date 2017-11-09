class User < ApplicationRecord
  has_many :user_emails, dependent: :destroy
  accepts_nested_attributes_for :user_emails, allow_destroy: true

  validates :fax_number, presence: true, length: {maximum: 60}, phone: {possible: true}

  before_save :format_fax_number, :generate_fax_tag

  private

    def format_fax_number
      self.fax_number = Phonelib.parse(fax_number).e164
    end

    def generate_fax_tag
      return if fax_tag.present?
      self.fax_tag = SecureRandom.uuid
    end
end
