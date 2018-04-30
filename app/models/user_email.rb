class UserEmail < ApplicationRecord
  belongs_to :user
  has_many :user_fax_numbers

  validates :email,
    presence: true,
    # uniqueness: {case_sensitive: false},
    length: {maximum: 60},
    email: true
end