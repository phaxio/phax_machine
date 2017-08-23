class EmailValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    return if value.blank?
    unless value =~ %r{^[^@]+@[^@]+$}
      object.errors.add attribute, "is not a valid email address"
    end
  end
end
