FactoryGirl.define do
  factory(:user) do
    email { Faker::Internet.email }
    # Unfortunately faker's generated phone numbers aren't accepted by phonelib.
    fax_number { '+12251231234' }
    password {"password"}
  end
end
