# frozen_string_literal: true

# == Schema Information
#
# Table name: employments
#
#  id         :bigint           not null, primary key
#  name       :string
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Employment, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_many(:vacancies) }
  it { is_expected.to have_many(:translations).dependent(:destroy) }

  it 'is valid with unique name' do
    create(:employment, name: 'Employment')
    employment = build(:employment, name: 'Another employment')
    expect(employment).to be_valid
  end

  it 'is invalid with unique name in the different case' do
    create(:employment, name: 'Employment')
    employment = build(:employment, name: 'employment')
    expect(employment).not_to be_valid
  end
end
