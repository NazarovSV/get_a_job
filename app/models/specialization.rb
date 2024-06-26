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
class Specialization < ApplicationRecord
  has_many :vacancies

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  translates :name, dependent: :destroy
end
