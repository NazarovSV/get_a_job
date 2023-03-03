# frozen_string_literal: true

# == Schema Information
#
# Table name: exchange_rates
#
#  id               :bigint           not null, primary key
#  rate             :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  from_currency_id :bigint           not null
#  to_currency_id   :bigint           not null
#
# Indexes
#
#  index_exchange_rates_on_from_currency_id  (from_currency_id)
#  index_exchange_rates_on_to_currency_id    (to_currency_id)
#
# Foreign Keys
#
#  fk_rails_...  (from_currency_id => currencies.id)
#  fk_rails_...  (to_currency_id => currencies.id)
#
FactoryBot.define do
  factory :exchange_rate do
    from_currency { nil }
    to_currency { nil }
    rate { 1.5 }
  end
end
