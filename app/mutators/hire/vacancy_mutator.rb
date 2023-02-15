# frozen_string_literal: true

module Hire::VacancyMutator
  class << self
    def create_vacancy_with_location(vacancy_params:, current_employer:, address_params:)
      vacancy = current_employer.vacancies.build(vacancy_params)
      location = Location.new(address: address_params)
      location.vacancy = vacancy

      ActiveRecord::Base.transaction do
        vacancy.save!
        location.save!
      end
      vacancy
    rescue ActiveRecord::RecordInvalid => e
      vacancy.valid?
      vacancy.errors.full_messages.concat(location.errors.full_messages)
      vacancy
    rescue StandardError => e
      vacancy.errors.add(:base, 'An error occurred while creating the vacancy')
      vacancy
    end
  end
end
