# frozen_string_literal: true

class SearchService
  def self.call(keywords: '', filters: {})
    Vacancy.published
           .look(keywords)
           .filtered_by_city(filters[:city_id])
           .filtered_by_experience(filters[:experience_id])
           .filtered_by_employment(filters[:employment_id])
           .filtered_by_salary(salary_min: filters[:salary_min]&.to_i,
                               salary_max: filters[:salary_max]&.to_i,
                               currency_id: filters[:currency_id]&.to_i)
  end
end
