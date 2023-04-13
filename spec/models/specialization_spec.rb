# frozen_string_literal: true

# == Schema Information
#
# Table name: specializations
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Specialization, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_many(:vacancies) }
  it { is_expected.to have_many(:translations).dependent(:destroy) }

  it 'is valid with unique name' do
    create(:specialization, name: 'Specialization')
    specialization = build(:specialization, name: 'Another specialization')
    expect(specialization).to be_valid
  end

  it 'is invalid with unique name in the different case' do
    create(:specialization, name: 'Specialization')
    specialization = build(:specialization, name: 'specialization')
    expect(specialization).not_to be_valid
  end
end
