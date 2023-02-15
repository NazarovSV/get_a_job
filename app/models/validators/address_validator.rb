# frozen_string_literal: true

class AddressValidator < ActiveModel::Validator
  def validate(record)
    return if !record.latitude.nil? && !record.longitude.nil?

    record.errors.add(:address, I18n.t('.invalid'))
  end
end
