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

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :code, presence: true, uniqueness: true
end
