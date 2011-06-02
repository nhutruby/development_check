class PostalCodeFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    if object.country == "United States" or object.country == "Canada"
      unless !value.blank?
        object.errors[attribute] << (options[:message] || "cannot be left blank")
      end
    end
  end
end