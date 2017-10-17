FactoryGirl.define do
  factory(:user_email) do
    user
    email { Faker::Internet.email }
  end
end