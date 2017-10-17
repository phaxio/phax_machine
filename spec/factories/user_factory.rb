FactoryGirl.define do
  factory(:user) do
    # Unfortunately faker's generated phone numbers aren't accepted by phonelib.
    fax_number { '+12251231234' }
  end
end
