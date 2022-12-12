# frozen_string_literal: true

# == Schema Information
#
# Table name: vacancies
#
#  id          :bigint           not null, primary key
#  description :string           not null
#  email       :string           not null
#  phone       :string
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Vacancy < ApplicationRecord
  include ActiveModel::Validations

  validates_with PhoneNumberValidator
  validates :title, :description, :email, presence: true
  validates_length_of :title, maximum: 128
end
