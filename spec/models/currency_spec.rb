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
require 'rails_helper'

RSpec.describe Currency, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to have_many(:vacancies) }

  describe 'is valid with unique name' do
    subject { Currency.new(name: 'RUB', code: 'RUB') }

    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'is valid with unique code' do
    subject { Currency.new(name: 'RUB', code: 'RUB') }

    it { is_expected.to validate_uniqueness_of(:code) }
  end
end
