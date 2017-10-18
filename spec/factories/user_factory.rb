FactoryGirl.define do
  factory(:user) do
    # Unfortunately faker's generated phone numbers aren't accepted by phonelib.
    fax_number { '+12251231234' }

    transient do
      user_email_count { Array(1..3).sample }
    end

    after(:create) do |user, evaluator|
      create_list :user_email, evaluator.user_email_count, user: user
    end
  end
end
