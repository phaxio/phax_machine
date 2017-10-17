require 'rails_helper'

RSpec.describe UserEmail, type: :model do
  subject(:user_email) { build :user_email }

  it 'has a valid factory' do
    expect(user_email).to be_valid
  end

  describe 'associations' do
    it 'belongs to a user' do
      expect(UserEmail.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'requires that user be set' do
      user_email.user = nil
      expect(user_email).to_not be_valid
      expect(user_email.errors[:user]).to include("must exist")
    end

    it 'requires that email be set' do
      user_email.email = nil
      expect(user_email).to_not be_valid
      expect(user_email.errors[:email]).to include("can't be blank")
    end

    it 'requires that email be unique' do
      create :user_email, email: 'test@example.com'
      user_email.email = 'test@example.com'
      expect(user_email).to_not be_valid
      expect(user_email.errors[:email]).to include('has already been taken')
    end

    it 'requires that email be no longer than 60 chars' do
      user_email.email = "-" * 61
      expect(user_email).to_not be_valid
      expect(user_email.errors[:email]).to include("is too long (maximum is 60 characters)")
    end

    it 'requires that email be a valid email' do
      user_email.email = "This isn't right"
      expect(user_email).to_not be_valid
      expect(user_email.errors[:email]).to include("is not a valid email address")
    end
  end
end