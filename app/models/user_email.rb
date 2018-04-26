class UserEmail < ApplicationRecord
  belongs_to :user
  belongs_to :user_fax_number

  validates :email,
    presence: true,
    uniqueness: {case_sensitive: false},
    length: {maximum: 60},
    email: true
end