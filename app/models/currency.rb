# frozen_string_literal: true

# == Schema Information
#
# Table name: currencies
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Currency < ApplicationRecord
  has_many :vacancies
  has_many :from_exchange_rates, class_name: 'ExchangeRate', foreign_key: :from_currency_id
  has_many :to_exchange_rates, class_name: 'ExchangeRate', foreign_key: :to_currency_id

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :code, presence: true, uniqueness: true
end
