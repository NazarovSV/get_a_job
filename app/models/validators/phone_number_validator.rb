# frozen_string_literal: true

require 'telephone_number'

class PhoneNumberValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:phone, 'is not valid') unless phone_valid?(record.phone)
  end

  private

  def phone_valid?(phone)
    phone.nil? || phone.empty? || TelephoneNumber.valid?(phone, :RU)
  end
end
