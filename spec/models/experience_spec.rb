# frozen_string_literal: true

# == Schema Information
#
# Table name: experiences
#
#  id          :bigint           not null, primary key
#  description :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Experience, type: :model do
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to have_many(:vacancies) }
  it { is_expected.to have_many(:translations).dependent(:destroy) }

  it 'is valid with unique description' do
    create(:experience, description: '1+')
    experience = build(:experience, description: '2+')
    expect(experience).to be_valid
  end

  it 'is invalid with unique name in the different case' do
    create(:experience, description: 'Experience')
    experience = build(:experience, description: 'experience')
    expect(experience).not_to be_valid
  end
end
