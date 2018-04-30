class User < ApplicationRecord
  has_many :user_emails, dependent: :destroy
  has_many :user_fax_numbers, dependent: :destroy
  
  accepts_nested_attributes_for :user_emails, allow_destroy: true
  accepts_nested_attributes_for :user_fax_numbers, allow_destroy: true

  before_save :generate_fax_tag

  private

    def generate_fax_tag
      return if fax_tag.present?
      self.fax_tag = SecureRandom.uuid
    end
end
