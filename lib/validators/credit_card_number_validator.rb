class CreditCardNumberValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    #fake validator for client side validation
  end
end
