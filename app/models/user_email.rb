class UserEmail < ApplicationRecord
  belongs_to :user

  validates :email,
    presence: true,
    # uniqueness: {case_sensitive: false},
    length: {maximum: 60},
    email: true
end