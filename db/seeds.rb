# frozen_string_literal: true

def create_category_with_translate(en_name:, ru_name:)
  employment = Employment.new(name: en_name)
  employment.name_translations = { en: en_name, ru: ru_name }
  employment.save!
end

unless Employment.any?
  create_category_with_translate(en_name: 'Full', ru_name: 'Полный')
  create_category_with_translate(en_name: 'Partial', ru_name: 'Частичный')
  create_category_with_translate(en_name: 'Shift', ru_name: 'Сменный')
  create_category_with_translate(en_name: 'Remote', ru_name: 'Удаленный')
  create_category_with_translate(en_name: 'Rotational', ru_name: 'Вахтовый')
end

unless Currency.any?
  Currency.create(name: 'Руб', code: 'RUB')
  Currency.create(name: 'USD', code: 'USD')
  Currency.create(name: 'EURO', code: 'EUR')
end

def create_experience_with_translate(en_description:, ru_description:)
  experience = Experience.new(description: ru_description)
  experience.description_translations = { en: en_description, ru: ru_description }
  experience.save!
end

unless Experience.any?
  create_experience_with_translate(en_description: 'No need', ru_description: 'Опыт не требуется')
  create_experience_with_translate(en_description: '1+ years', ru_description: '1+ год опыта')
  create_experience_with_translate(en_description: '1-3 years', ru_description: '1 - 3 года опыта')
  create_experience_with_translate(en_description: '3-5 years', ru_description: '3 - 5 лет опыта')
  create_experience_with_translate(en_description: '5+ year', ru_description: '5 + лет опыта')
end

def create_specialization_with_translate(en_name:, ru_name:)
  specialization = Specialization.new(name: en_name)
  specialization.name_translations = { en: en_name, ru: ru_name }
  specialization.save!
end

unless Specialization.any?
  create_specialization_with_translate(en_name: 'Driver', ru_name: 'Водитель')
  create_specialization_with_translate(en_name: 'IT', ru_name: 'IT')
  create_specialization_with_translate(en_name: 'Manager', ru_name: 'Менеджер')
  create_specialization_with_translate(en_name: 'Doctor', ru_name: 'Доктор')
end
