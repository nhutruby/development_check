class DescriptionValidator < ActiveModel::EachValidator

  def validate_each(object, attribute, value) 
      #description = object.description.split(" ")
      #description = description.split(".")
      #description = description.split("/")
    if object.description.blank?
      true
    else
      if object.description.include? ".com" or object.description.include? ".org" or object.description.include? ".edu" or object.description.include? ".gov" or object.description.include? "@"
        object.errors[attribute] << (options[:message] || "cannot contain email addresses or website URLs (.com, .gov, etc.)")     
      else
        true      
      end
    end
  end

end