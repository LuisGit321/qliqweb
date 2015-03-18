class SubscriberEmailValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    existing_user = User.find_by_email(value)
      if existing_user
        object.errors[attribute] << (options[:message] || "already taken")
      end
    end
end
