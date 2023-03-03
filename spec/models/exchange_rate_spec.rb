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
require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  it { should belong_to(:from_currency).class_name(:Currency) }
  it { should belong_to(:to_currency).class_name(:Currency) }
  it { should validate_presence_of(:rate) }
  it { should validate_numericality_of(:rate).is_greater_than_or_equal_to(0) }
end
