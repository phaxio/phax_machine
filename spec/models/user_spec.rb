require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build :user }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  it 'requires that email be present' do
    user.email = nil
    expect(user).to_not be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'requires that email be no longer than 60 chars' do
    user.email = "-" * 61
    expect(user).to_not be_valid
    expect(user.errors[:email]).to include("is too long (maximum is 60 characters)")
  end

  it 'requires that email be a valid email' do
    user.email = "This isn't right"
    expect(user).to_not be_valid
    expect(user.errors[:email]).to include("is not a valid email address")
  end

  it 'requires that fax_number be present' do
    user.fax_number = nil
    expect(user).to_not be_valid
    expect(user.errors[:fax_number]).to include("can't be blank")
  end

  it 'requires that fax_number be no longer than 60 chars' do
    user.fax_number = "-" * 61
    expect(user).to_not be_valid
    expect(user.errors[:fax_number]).to include("is too long (maximum is 60 characters)")
  end

  it 'requires that fax_number be a valid phone number' do
    user.fax_number = "This isn't right"
    expect(user).to_not be_valid
    expect(user.errors[:fax_number]).to include("is invalid")
  end

  it 'formats the fax_number on save' do
    user.fax_number = "1 (225) 123 1234"
    expect(user.save).to eq(true)
    expect(user.fax_number).to eq("+12251231234")
  end
end
