# frozen_string_literal: true

# == Schema Information
#
# Table name: experiences
#
#  id          :bigint           not null, primary key
#  description :string
#  description :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Experience < ApplicationRecord
  has_many :vacancies

  validates :description, presence: true, uniqueness: { case_sensitive: false }
  translates :description, dependent: :destroy
end
