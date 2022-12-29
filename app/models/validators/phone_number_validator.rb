# frozen_string_literal: true

require 'telephone_number'

class PhoneNumberValidator < ActiveModel::Validator
  def validate(record)
    return if phone_valid?(record.phone)

    record.errors.add(:phone, I18n.t('errors.messages.invalid'))
  end

  private

  def phone_valid?(phone)
    phone_is_blank?(phone) || TelephoneNumber.valid?(phone, :RU)
  end

  def phone_is_blank?(phone)
    phone.blank?
  end
end
