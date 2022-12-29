# frozen_string_literal: true

# == Schema Information
#
# Table name: employers
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_employers_on_email                 (email) UNIQUE
#  index_employers_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe Employer, type: :model do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many(:vacancies).dependent(:destroy) }

  describe "checking the vacancy's author" do
    let(:vacancy) { create(:vacancy) }

    it 'current user is the author of the vacancy' do
      employer = vacancy.employer
      expect(employer).to be_author(vacancy)
    end

    it 'current user is not the author of the question' do
      employer = create(:employer)
      expect(employer).not_to be_author(vacancy)
    end
  end
end
