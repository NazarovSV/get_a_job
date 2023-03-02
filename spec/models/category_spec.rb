# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Category, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_many(:vacancies) }
  it { is_expected.to have_many(:translations).dependent(:destroy) }

  it 'is valid with unique name' do
    create(:category, name: 'Category')
    category = build(:category, name: 'Another category')
    expect(category).to be_valid
  end

  it 'is invalid with unique name in the different locale' do
    create(:category, name: 'Category')
    category = build(:category, name: 'category')
    expect(category).not_to be_valid
  end

  it 'is invalid with non unique name in the different locale' do
    create(:category, name: 'Category')
    category = build(:category, name: 'category')

    expect(category).not_to be_valid
  end
end
